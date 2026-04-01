#!/usr/bin/env bash
set -euo pipefail

STEP="${AUDIO_STEP:-5%}"

need() {
    command -v "$1" >/dev/null 2>&1 || {
        echo "missing command: $1" >&2
        exit 1
    }
}

need wpctl
need awk
need sed
need grep

audio_sink_ids() {
    wpctl status 2>/dev/null | awk '
        BEGIN {
            in_audio = 0
            in_sinks = 0
        }

        /^Audio[[:space:]]*$/ {
            in_audio = 1
            in_sinks = 0
            next
        }

        /^Video[[:space:]]*$/ {
            in_audio = 0
            in_sinks = 0
            next
        }

        in_audio && /Sinks:/ {
            in_sinks = 1
            next
        }

        in_audio && in_sinks && /Sources:/ {
            in_sinks = 0
            next
        }

        in_audio && in_sinks {
            if (match($0, /[0-9]+\./)) {
                id = substr($0, RSTART, RLENGTH)
                sub(/\.$/, "", id)
                print id
            }
        }
    ' | sort -n | uniq
}

default_sink_id() {
    wpctl status 2>/dev/null | awk '
        BEGIN {
            in_audio = 0
            in_sinks = 0
        }

        /^Audio[[:space:]]*$/ {
            in_audio = 1
            in_sinks = 0
            next
        }

        /^Video[[:space:]]*$/ {
            in_audio = 0
            in_sinks = 0
            next
        }

        in_audio && /Sinks:/ {
            in_sinks = 1
            next
        }

        in_audio && in_sinks && /Sources:/ {
            in_sinks = 0
            next
        }

        in_audio && in_sinks && /\*/ {
            if (match($0, /[0-9]+\./)) {
                id = substr($0, RSTART, RLENGTH)
                sub(/\.$/, "", id)
                print id
                exit
            }
        }
    '
}

inspect_prop() {
    local id="$1"
    local key="$2"

    wpctl inspect "$id" 2>/dev/null | awk -v key="$key" '
        index($0, key) {
            line = $0

            # Keep only text after first "="
            sub(/^[^=]*=[[:space:]]*/, "", line)

            # Trim surrounding whitespace
            sub(/^[[:space:]]+/, "", line)
            sub(/[[:space:]]+$/, "", line)

            # Remove one layer of surrounding quotes if present
            if (line ~ /^".*"$/) {
                sub(/^"/, "", line)
                sub(/"$/, "", line)
            }

            print line
            exit
        }
    '
}

sink_desc() {
    local id="$1"
    local v=""

    for key in \
        "node.description" \
        "device.description" \
        "node.nick" \
        "node.name"; do
        v="$(inspect_prop "$id" "$key")"
        [[ -n "$v" ]] && break
    done

    [[ -n "$v" ]] || v="Sink $id"
    printf '%s\n' "$v"
}

sink_name() {
    local id="$1"
    local v=""
    v="$(inspect_prop "$id" "node.name")"
    [[ -n "$v" ]] || v="-"
    printf '%s\n' "$v"
}


get_volume_line() {
    local id="$1"
    wpctl get-volume "$id" 2>/dev/null || true
}

volume_percent() {
    local id="$1"
    local line vol
    line="$(get_volume_line "$id")"
    vol="$(awk '{for(i=1;i<=NF;i++) if($i ~ /^[0-9.]+$/){print $i; exit}}' <<<"$line")"
    [[ -n "${vol:-}" ]] || vol="0"
    awk -v v="$vol" 'BEGIN { printf "%d", (v * 100) + 0.5 }'
}

is_muted() {
    local id="$1"
    get_volume_line "$id" | grep -q '\[MUTED\]'
}

icon_for_volume() {
    local pct="$1"
    local muted="${2:-0}"

    if [[ "$muted" = "1" ]]; then
        printf '󰝟'
    elif (( pct == 0 )); then
        printf '󰕿'
    elif (( pct < 35 )); then
        printf '󰖀'
    else
        printf '󰕾'
    fi
}


json_escape() {
    awk '
        BEGIN { first = 1 }
        {
            gsub(/\\/,"\\\\")
            gsub(/"/,"\\\"")
            if (!first) printf "\\n"
            printf "%s", $0
            first = 0
        }
    '
}

status_json() {
    local id desc name pct muted icon class tooltip

    id="$(default_sink_id)"

    if [[ -z "${id:-}" ]]; then
        printf '{"text":"󰝟 --","tooltip":"No default audio sink","class":["audio","missing"]}\n'
        return
    fi

    desc="$(sink_desc "$id")"
    name="$(sink_name "$id")"
    pct="$(volume_percent "$id")"

    if is_muted "$id"; then
        muted=1
        class="audio muted"
    else
        muted=0
        class="audio"
    fi

    icon="$(icon_for_volume "$pct" "$muted")"

    tooltip=$(
        cat <<EOF
Default sink: $desc
Node: $name
ID: $id
Volume: ${pct}%
Muted: $( [[ "$muted" = "1" ]] && echo yes || echo no )

Left click: mute
Scroll: volume up/down
Right click: choose sink
EOF
    )

    printf '{"text":"%s %s%%","tooltip":"%s","class":["%s"]}\n' \
        "$icon" "$pct" \
        "$(printf '%s' "$tooltip" | json_escape)" \
        "$class"
}

cmd="${1:-status}"

case "$cmd" in
    status)
        status_json
        ;;
    up)
        wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ "${STEP}+"
        ;;
    down)
        wpctl set-volume -l 1.0  @DEFAULT_AUDIO_SINK@ "${STEP}-"
        ;;
    mute)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        ;;
    list)
        while IFS= read -r id; do
            printf '%s\t%s\n' "$id" "$(sink_desc "$id")"
        done < <(audio_sink_ids)
        ;;
    *)
        echo "usage: $0 {status|up|down|mute|list}" >&2
        exit 1
        ;;
esac

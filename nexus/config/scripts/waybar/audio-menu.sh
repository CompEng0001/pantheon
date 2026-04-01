#!/usr/bin/env bash
set -euo pipefail

launcher() {
    if command -v wofi >/dev/null 2>&1; then
        printf 'wofi\n'
    elif command -v rofi >/dev/null 2>&1; then
        printf 'rofi\n'
    else
        echo "Need wofi or rofi" >&2
        exit 1
    fi
}

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
            sub(/^[^=]*=[[:space:]]*/, "", line)
            sub(/^[[:space:]]+/, "", line)
            sub(/[[:space:]]+$/, "", line)
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

run_launcher() {
    local app="$1"
    case "$app" in
        wofi)
            wofi --dmenu --prompt "Audio sink"
            ;;
        rofi)
            rofi -dmenu -p "Audio sink"
            ;;
        *)
            exit 1
            ;;
    esac
}

app="$(launcher)"
current="$(default_sink_id)"

choices="$(
    while IFS= read -r id; do
        [[ -n "$id" ]] || continue
        label="$(sink_desc "$id")"
        if [[ "$id" = "$current" ]]; then
            printf '✓ %s\t%s\n' "$label" "$id"
        else
            printf '%s\t%s\n' "$label" "$id"
        fi
    done < <(audio_sink_ids)
)"

selected_label="$(
    printf '%s\n' "$choices" | cut -f1 | run_launcher "$app"
)"

[[ -n "${selected_label:-}" ]] || exit 0

selected_id="$(
    printf '%s\n' "$choices" | awk -F '\t' -v sel="$selected_label" '$1 == sel { print $2; exit }'
)"

[[ -n "${selected_id:-}" ]] || exit 1

wpctl set-default "$selected_id"

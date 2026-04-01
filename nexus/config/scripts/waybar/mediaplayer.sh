#!/usr/bin/env bash
set -euo pipefail

STATE_DIR="${XDG_RUNTIME_DIR:-/tmp}/waybar-media"
FOCUS_FILE="$STATE_DIR/focus"
mkdir -p "$STATE_DIR"

need() {
    command -v "$1" >/dev/null 2>&1 || {
        echo "missing command: $1" >&2
        exit 1
    }
}

need playerctl
need awk
need sed
need grep
need cut
need tr

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

list_players() {
    playerctl -l 2>/dev/null | awk 'NF' | sort -u
}

player_status() {
    local p="$1"
    playerctl -p "$p" status 2>/dev/null || true
}

player_title() {
    local p="$1"
    playerctl -p "$p" metadata title 2>/dev/null || true
}

player_artist() {
    local p="$1"
    playerctl -p "$p" metadata artist 2>/dev/null || true
}

short_name() {
    case "$1" in
        firefox*|*Firefox*) echo "Firefox" ;;
        spotify*|*Spotify*) echo "Spotify" ;;
        vlc*|*VLC*) echo "VLC" ;;
        mpv*|*MPV*) echo "mpv" ;;
        chromium*|*Chromium*) echo "Chromium" ;;
        brave*|*Brave*) echo "Brave" ;;
        teams*|*Teams*) echo "Teams" ;;
        *) echo "$1" ;;
    esac
}

player_icon() {
    case "$1" in
        firefox*|*Firefox*) printf '󰈹' ;;
        spotify*|*Spotify*) printf '' ;;
        vlc*|*VLC*) printf '󰕼' ;;
        mpv*|*MPV*) printf '󰐹' ;;
        chromium*|*Chromium*) printf '' ;;
        brave*|*Brave*) printf '󰖟' ;;
        teams*|*Teams*) printf '󰊻' ;;
        *) printf '󰎆' ;;
    esac
}

status_icon() {
    case "$1" in
        Playing) printf '󰐊' ;;
        Paused)  printf '󰏤' ;;
        Stopped) printf '󰓛' ;;
        *)       printf '󰎇' ;;
    esac
}

truncate() {
    local s="${1:-}"
    local n="${2:-30}"
    awk -v s="$s" -v n="$n" 'BEGIN {
        if (length(s) <= n) print s;
        else print substr(s, 1, n-1) "…";
    }'
}

focus_get() {
    [[ -f "$FOCUS_FILE" ]] && cat "$FOCUS_FILE" || true
}

focus_set() {
    printf '%s\n' "$1" > "$FOCUS_FILE"
}

default_focus() {
    local p
    while IFS= read -r p; do
        [[ -n "$p" ]] || continue
        if [[ "$(player_status "$p")" = "Playing" ]]; then
            printf '%s\n' "$p"
            return 0
        fi
    done < <(list_players)

    list_players | head -n1
}

ensure_focus() {
    local current found
    current="$(focus_get)"
    found=0

    if [[ -n "$current" ]]; then
        while IFS= read -r p; do
            [[ "$p" = "$current" ]] && found=1 && break
        done < <(list_players)
    fi

    if [[ "$found" -eq 1 ]]; then
        printf '%s\n' "$current"
    else
        default_focus
    fi
}

cycle_focus() {
    mapfile -t players < <(list_players)
    [[ "${#players[@]}" -gt 0 ]] || exit 0

    local current next i
    current="$(ensure_focus)"
    next="${players[0]}"

    for ((i = 0; i < ${#players[@]}; i++)); do
        if [[ "${players[$i]}" = "$current" ]]; then
            next="${players[$(( (i + 1) % ${#players[@]} ))]}"
            break
        fi
    done

    focus_set "$next"
}

control_focused() {
    local cmd="$1"
    local focused
    focused="$(ensure_focus)"
    [[ -n "$focused" ]] || exit 0
    focus_set "$focused"
    playerctl -p "$focused" "$cmd"
}

render() {
    mapfile -t players < <(list_players)

    if [[ "${#players[@]}" -eq 0 ]]; then
        printf '{"text":"󰎇","tooltip":"No media players","class":["media","empty"]}\n'
        return
    fi

    local focused
    focused="$(ensure_focus)"
    [[ -n "$focused" ]] && focus_set "$focused"

    local text_parts=()
    local tooltip_lines=()
    local p status title artist icon sicon mark label line count
    count=0

    for p in "${players[@]}"; do
        status="$(player_status "$p")"
        title="$(player_title "$p")"
        artist="$(player_artist "$p")"
        icon="$(player_icon "$p")"
        sicon="$(status_icon "$status")"

        [[ -n "$title" ]] || title="(no title)"
        if [[ -n "$artist" ]]; then
            label="$artist — $title"
        else
            label="$title"
        fi
        if [[ "$p" = "$focused" ]]; then
            mark="▶"
            text_parts+=("${icon}  ${sicon} $label")
        else
            mark=" "
        fi
        line="${mark} $(short_name "$p") [$status]"
        if [[ -n "$artist" ]]; then
            line="${line}: $artist — $title"
        else
            line="${line}: $title"
        fi
        tooltip_lines+=("$line")
        count=$((count + 1))
    done

    if [[ "${#text_parts[@]}" -eq 0 ]]; then
        # No focused/playing item in text; show first player compactly
        p="${players[0]}"
        status="$(player_status "$p")"
        title="$(player_title "$p")"
        icon="$(player_icon "$p")"
        sicon="$(status_icon "$status")"
        [[ -n "$title" ]] || title="$(short_name "$p")"
        if [[ -n "$artist" ]]; then
            text_parts+=("${icon}${sicon} $artist — $title")
        else
            text_parts+=("${icon}${sicon} $title")
        fi
    fi

    local text tooltip
    text="$(printf ' | %s' "${text_parts[@]}")"
    text="${text:3}"

    tooltip="Focused: $(short_name "$focused")"$'\n'
    tooltip+="Players: $count"$'\n\n'
    tooltip+="$(printf '%s\n' "${tooltip_lines[@]}")"

    printf '{"text":"%s ","tooltip":"%s","class":["media"]}\n' \
        "$(printf '%s' "$text" | sed 's/"/\\"/g')" \
        "$(printf '%s\n' "$tooltip" | json_escape)"
}

case "${1:-status}" in
    status)
        render
        ;;
    play-pause)
        control_focused play-pause
        ;;
    next)
        control_focused next
        ;;
    previous)
        control_focused previous
        ;;
    cycle)
        cycle_focus
        ;;
    *)
        echo "usage: $0 {status|play-pause|next|previous|cycle}" >&2
        exit 1
        ;;
esac

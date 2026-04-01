#!/usr/bin/env bash
set -u

STATE_FILE="/tmp/waybar-apc-last-state"
APCACCESS_BIN="${APCACCESS_BIN:-apcaccess}"

if ! command -v "$APCACCESS_BIN" >/dev/null 2>&1; then
    printf '{"text":"APC Status: unavailable","class":"critical","tooltip":"apcaccess not found"}\n'
    exit 0
fi

status_output="$("$APCACCESS_BIN" status 2>/dev/null)"
rc=$?

if [ $rc -ne 0 ] || [ -z "$status_output" ]; then
    printf '{"text":"APC Status: unavailable","class":"critical","tooltip":"Unable to read UPS status"}\n'
    exit 0
fi

get_field() {
    local key="$1"
    printf '%s\n' "$status_output" \
        | grep -m1 "^${key}[[:space:]]*:" \
        | sed 's/^[^:]*:[[:space:]]*//; s/[[:space:]]*$//'
}

json_escape() {
    local s="${1:-}"
    s=${s//\\/\\\\}
    s=${s//\"/\\\"}
    s=${s//$'\n'/\\n}
    printf '%s' "$s"
}

STATUS="$(get_field STATUS)"
BCHARGE="$(get_field BCHARGE)"
TIMELEFT="$(get_field TIMELEFT)"
MODEL="$(get_field MODEL)"
LINEV="$(get_field LINEV)"
BATTV="$(get_field BATTV)"
LASTXFER="$(get_field LASTXFER)"

[ -n "$STATUS" ] || STATUS="UNKNOWN"
[ -n "$BCHARGE" ] || BCHARGE="N/A"
[ -n "$TIMELEFT" ] || TIMELEFT="N/A"
[ -n "$MODEL" ] || MODEL="APC UPS"
[ -n "$LINEV" ] || LINEV="N/A"
[ -n "$BATTV" ] || BATTV="N/A"
[ -n "$LASTXFER" ] || LASTXFER="N/A"

class="warning"
text="APC Status: $STATUS"

case "$STATUS" in
    ONLINE)
        class="online"
        text="APC Status: $STATUS"
        ;;
    ONBATT|ONBATTERY)
        class="onbattery"
        text="APC Status: $STATUS | BCHARGE: $BCHARGE | TIMELEFT: $TIMELEFT"
        ;;
    *)
        class="warning"
        text="APC Status: $STATUS"
        ;;
esac

tooltip="Model: $MODEL
Status: $STATUS
Battery Charge: $BCHARGE
Time Left: $TIMELEFT
Line Voltage: $LINEV
Battery Voltage: $BATTV
Last Transfer: $LASTXFER"

last_state=""
if [ -f "$STATE_FILE" ]; then
    last_state="$(cat "$STATE_FILE" 2>/dev/null)"
fi

if [ "$STATUS" != "$last_state" ]; then
    printf '%s\n' "$STATUS" > "$STATE_FILE"

    if command -v notify-send >/dev/null 2>&1; then
        case "$STATUS" in
            ONBATT|ONBATTERY)
                notify-send \
                    -u critical \
                    -a "Waybar APC" \
                    "UPS on battery" \
                    "Battery charge: $BCHARGE
Estimated time left: $TIMELEFT"
                ;;
            ONLINE)
                if [ -n "$last_state" ]; then
                    notify-send \
                        -u normal \
                        -a "Waybar APC" \
                        "UPS back online" \
                        "Mains power restored"
                fi
                ;;
        esac
    fi
fi

printf '{"text":"%s","class":"%s","tooltip":"%s"}\n' \
    "$(json_escape "$text")" \
    "$(json_escape "$class")" \
    "$(json_escape "$tooltip")"

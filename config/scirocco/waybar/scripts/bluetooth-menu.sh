#!/usr/bin/env bash

set -u

ROFI=(rofi -dmenu -i)
SCAN_SECONDS=10

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "Bluetooth" "$1"
    fi
}

refresh_waybar() {
    pkill -RTMIN+8 waybar 2>/dev/null || true
}

powered() {
    bluetoothctl show 2>/dev/null |
        awk -F': ' '/Powered:/ { print $2; exit }'
}

known_devices() {
    bluetoothctl devices 2>/dev/null | grep '^Device ' || true
}

connected_devices() {
    local out

    # Newer BlueZ versions support this filter directly.
    if out="$(bluetoothctl devices Connected 2>/dev/null)"; then
        printf '%s\n' "$out" | grep '^Device ' || true
        return
    fi

    # Fallback for older versions.
    while IFS= read -r line; do
        [[ -z "$line" ]] && continue

        local rest mac
        rest="${line#Device }"
        mac="${rest%% *}"

        if bluetoothctl info "$mac" 2>/dev/null |
            grep -q 'Connected: yes'; then
            printf '%s\n' "$line"
        fi
    done < <(known_devices)
}

device_name_from_line() {
    local line="$1"
    local rest mac

    rest="${line#Device }"
    mac="${rest%% *}"

    printf '%s' "${rest#"$mac "}"
}

mac_from_selection() {
    printf '%s\n' "$1" |
        grep -oE '([[:xdigit:]]{2}:){5}[[:xdigit:]]{2}' |
        head -n1
}

json_escape() {
    local value="$1"

    value="${value//\\/\\\\}"
    value="${value//\"/\\\"}"
    value="${value//$'\n'/\\n}"
    value="${value//$'\r'/}"

    printf '%s' "$value"
}

status() {
    local state
    state="$(powered)"

    if [[ "$state" != "yes" ]]; then
        printf '{"text":"󰂲","tooltip":"Bluetooth off","class":"off"}\n'
        exit 0
    fi

    local connected=()
    local line name

    while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        name="$(device_name_from_line "$line")"
        connected+=("$name")
    done < <(connected_devices)

    if (( ${#connected[@]} == 0 )); then
        printf '{"text":"󰂯","tooltip":"Bluetooth on\\nNo devices connected","class":"on"}\n'
    else
        local tooltip="Bluetooth connected"
        for name in "${connected[@]}"; do
            tooltip+=$'\n'"• $name"
        done

        tooltip="$(json_escape "$tooltip")"

        printf \
            '{"text":"󰂱","tooltip":"%s","class":"connected","alt":"connected"}\n' \
            "$tooltip"
    fi
}

toggle_power() {
    if [[ "$(powered)" == "yes" ]]; then
        bluetoothctl power off >/dev/null
        notify "Powered off"
    else
        bluetoothctl power on >/dev/null
        notify "Powered on"
    fi

    refresh_waybar
}

scan() {
    bluetoothctl power on >/dev/null 2>&1 || true

    notify "Scanning for ${SCAN_SECONDS} seconds…"

    bluetoothctl --timeout "$SCAN_SECONDS" scan on >/dev/null 2>&1 || true

    device_menu
}

device_menu() {
    local menu=""
    local line rest mac name state

    while IFS= read -r line; do
        [[ -z "$line" ]] && continue

        rest="${line#Device }"
        mac="${rest%% *}"
        name="${rest#"$mac "}"

        if bluetoothctl info "$mac" 2>/dev/null |
            grep -q 'Connected: yes'; then
            state="●"
        else
            state="○"
        fi

        menu+="$state $name [$mac]"$'\n'
    done < <(known_devices)

    if [[ -z "$menu" ]]; then
        notify "No Bluetooth devices found"
        return
    fi

    local selected
    selected="$(printf '%s' "$menu" | "${ROFI[@]}" -p "Bluetooth devices")"

    [[ -z "$selected" ]] && return

    local mac
    mac="$(mac_from_selection "$selected")"

    [[ -n "$mac" ]] && device_actions "$mac"
}

device_actions() {
    local mac="$1"
    local info name connected paired trusted

    info="$(bluetoothctl info "$mac" 2>/dev/null)"

    name="$(
        printf '%s\n' "$info" |
            sed -n 's/^[[:space:]]*Name: //p' |
            head -n1
    )"

    [[ -z "$name" ]] && name="$mac"

    connected="no"
    paired="no"
    trusted="no"

    grep -q 'Connected: yes' <<< "$info" && connected="yes"
    grep -q 'Paired: yes' <<< "$info" && paired="yes"
    grep -q 'Trusted: yes' <<< "$info" && trusted="yes"

    local options=""

    if [[ "$connected" == "yes" ]]; then
        options+="Disconnect"$'\n'
    else
        options+="Connect"$'\n'
    fi

    if [[ "$paired" != "yes" ]]; then
        options+="Pair"$'\n'
    fi

    if [[ "$trusted" == "yes" ]]; then
        options+="Untrust"$'\n'
    else
        options+="Trust"$'\n'
    fi

    options+="Remove"$'\n'
    options+="Info"$'\n'

    local action
    action="$(
        printf '%s' "$options" |
            "${ROFI[@]}" -p "$name"
    )"

    [[ -z "$action" ]] && return

    local output

    case "$action" in
        Connect)
            output="$(bluetoothctl connect "$mac" 2>&1)"
            if grep -qi 'successful\|Connection successful' <<< "$output"; then
                notify "Connected to $name"
            else
                notify "Could not connect to $name"
            fi
            ;;

        Disconnect)
            bluetoothctl disconnect "$mac" >/dev/null 2>&1
            notify "Disconnected from $name"
            ;;

        Pair)
            output="$(bluetoothctl pair "$mac" 2>&1)"

            if grep -qi 'Pairing successful' <<< "$output"; then
                bluetoothctl trust "$mac" >/dev/null 2>&1
                notify "Paired and trusted $name"
            else
                notify "Pairing failed for $name"
            fi
            ;;

        Trust)
            bluetoothctl trust "$mac" >/dev/null 2>&1
            notify "Trusted $name"
            ;;

        Untrust)
            bluetoothctl untrust "$mac" >/dev/null 2>&1
            notify "Untrusted $name"
            ;;

        Remove)
            local confirm
            confirm="$(
                printf 'No\nYes\n' |
                    "${ROFI[@]}" -p "Remove $name?"
            )"

            if [[ "$confirm" == "Yes" ]]; then
                bluetoothctl remove "$mac" >/dev/null 2>&1
                notify "Removed $name"
            fi
            ;;

        Info)
            printf '%s\n' "$info" |
                "${ROFI[@]}" -p "$name" -no-custom
            ;;
    esac

    refresh_waybar
}

main_menu() {
    local state option

    state="$(powered)"

    if [[ "$state" == "yes" ]]; then
        option="$(
            printf '%s\n' \
                "Devices" \
                "Scan for devices" \
                "Power off" |
                "${ROFI[@]}" -p "Bluetooth"
        )"
    else
        option="$(
            printf '%s\n' \
                "Power on" |
                "${ROFI[@]}" -p "Bluetooth"
        )"
    fi

    case "$option" in
        "Devices")
            device_menu
            ;;
        "Scan for devices")
            scan
            ;;
        "Power on")
            bluetoothctl power on >/dev/null
            refresh_waybar
            ;;
        "Power off")
            bluetoothctl power off >/dev/null
            refresh_waybar
            ;;
    esac
}

case "${1:-}" in
    --status)
        status
        ;;
    --toggle-power)
        toggle_power
        ;;
    --scan)
        scan
        ;;
    *)
        main_menu
        ;;
esac

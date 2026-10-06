#!/usr/bin/env bash

set -euo pipefail

CONFIG="$HOME/.config/waybar/config.jsonc"

RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp}/waybar"
RUNTIME_CONFIG="$RUNTIME_DIR/config.jsonc"

mkdir -p "$RUNTIME_DIR"

resolve_output() {
    local outputs="$1"
    local make="$2"
    local model="$3"
    local serial="$4"

    jq -r \
        --arg make "$make" \
        --arg model "$model" \
        --arg serial "$serial" '
        to_entries[]
        | select(
            .value.make == $make
            and .value.model == $model
            and .value.serial == $serial
        )
        | .key
    ' <<< "$outputs"
}

#
# Kanshi can execute this script immediately after applying the
# profile. Give Niri a short period in which to expose all of the
# newly configured outputs.
#
WB_DL_LEFT=""
WB_DL_CENTRE=""
WB_DL_RIGHT=""

for _ in {1..20}; do
    outputs="$(niri msg --json outputs)"

    WB_DL_LEFT="$(
        resolve_output \
            "$outputs" \
            "Iiyama North America" \
            "PL2493H" \
            "1187721200661"
    )"

    WB_DL_CENTRE="$(
        resolve_output \
            "$outputs" \
            "Iiyama North America" \
            "PL2779Q" \
            "0"
    )"

    WB_DL_RIGHT="$(
        resolve_output \
            "$outputs" \
            "Iiyama North America" \
            "PL2493H" \
            "1187721208215"
    )"

    if [[ -n "$WB_DL_LEFT" &&
          -n "$WB_DL_CENTRE" &&
          -n "$WB_DL_RIGHT" ]]; then
        break
    fi

    sleep 0.25
done

echo "[waybar] DisplayLink left   -> ${WB_DL_LEFT:-not connected}"
echo "[waybar] DisplayLink centre -> ${WB_DL_CENTRE:-not connected}"
echo "[waybar] DisplayLink right  -> ${WB_DL_RIGHT:-not connected}"

#
# Absolutely do not generate a configuration with missing output names.
#
if [[ -z "$WB_DL_LEFT" ||
      -z "$WB_DL_CENTRE" ||
      -z "$WB_DL_RIGHT" ]]; then

    echo "[waybar] ERROR: Could not resolve all DisplayLink outputs." >&2
    exit 1
fi

#
# Escape replacement strings for sed.
#
sed_escape() {
    printf '%s' "$1" | sed 's/[&|\\]/\\&/g'
}

LEFT="$(sed_escape "$WB_DL_LEFT")"
CENTRE="$(sed_escape "$WB_DL_CENTRE")"
RIGHT="$(sed_escape "$WB_DL_RIGHT")"

tmp="$(mktemp "$RUNTIME_DIR/config.jsonc.XXXXXX")"
trap 'rm -f "$tmp"' EXIT

#
# config.jsonc contains literal:
#
#   $WB_DL_LEFT
#   $WB_DL_CENTRE
#   $WB_DL_RIGHT
#
# Replace them only in the generated runtime copy.
#
sed \
    -e "s|\\\$WB_DL_LEFT|${LEFT}|g" \
    -e "s|\\\$WB_DL_CENTRE|${CENTRE}|g" \
    -e "s|\\\$WB_DL_RIGHT|${RIGHT}|g" \
    "$CONFIG" > "$tmp"

#
# Sanity check: no unresolved DisplayLink variables should remain.
#
if grep -q '\$WB_DL_' "$tmp"; then
    echo "[waybar] ERROR: unresolved output variables remain:" >&2
    grep '\$WB_DL_' "$tmp" >&2
    exit 1
fi

mv "$tmp" "$RUNTIME_CONFIG"
trap - EXIT

pkill waybar 2>/dev/null || true

exec waybar -c "$RUNTIME_CONFIG"

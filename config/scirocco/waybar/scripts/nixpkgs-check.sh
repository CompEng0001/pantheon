
#!/usr/bin/env bash

set -uo pipefail

FLAKE_DIR="${NIX_FLAKE_DIR:-$HOME/Git/pantheon}"
LOCK="$FLAKE_DIR/flake.lock"

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/waybar"
CACHE="$CACHE_DIR/nixpkgs-status.json"
STAMP="$CACHE_DIR/nixpkgs-checked"
TTL=86400

mkdir -p "$CACHE_DIR"

show_status() {
    local status="$1"
    local message="$2"
    local detail="${3:-}"

    jq -cn \
        --arg status "$status" \
        --arg message "$message" \
        --arg detail "$detail" \
        '{
            text: $message,
            tooltip: $detail,
            class: $status
        }'
}

if [[ ! -f "$LOCK" ]]; then
    show_status "error" "󰅚 Nixpkgs" "flake.lock not found"
    exit 0
fi

# Detect changes to the lock file.
local_rev=$(jq -r \
    '.nodes.nixpkgs.locked.rev // empty' "$LOCK")

branch=$(jq -r \
    '.nodes.nixpkgs.original.ref // empty' "$LOCK")

repo=$(jq -r \
    '.nodes.nixpkgs.original.repo // empty' "$LOCK")

owner=$(jq -r \
    '.nodes.nixpkgs.original.owner // empty' "$LOCK")

if [[ -z "$local_rev" || -z "$branch" ||
      -z "$repo" || -z "$owner" ]]; then
    show_status "error" "󰅚 Nixpkgs" "Unsupported nixpkgs input"
    exit 0
fi

now=$(date +%s)

# Reuse the cached result if still fresh and the
# locally locked revision has not changed.
if [[ "${1:-}" != "--force" &&
      -f "$STAMP" && -f "$CACHE" ]]; then

    checked=$(cat "$STAMP")
    cached_rev=$(jq -r \
        '.local_rev // empty' "$CACHE")

    if [[ "$checked" =~ ^[0-9]+$ ]] &&
       (( now >= checked && now - checked < TTL )) &&
       [[ "$cached_rev" == "$local_rev" ]]; then
        jq -c '{text, tooltip, class}' "$CACHE"
        exit 0
    fi
fi

url="github:$owner/$repo/$branch"

remote_rev=$(nix flake metadata \
    --refresh --json "$url" 2>/dev/null |
    jq -r '.locked.rev // empty') || remote_rev=""

if [[ -z "$remote_rev" ]]; then
    show_status "error" "󰅚 Nixpkgs" \
        "Could not check upstream nixpkgs"
    exit 0
fi

if [[ "$local_rev" == "$remote_rev" ]]; then
    status="updated"
    message="󰄬 Nixpkgs"
    description="nixpkgs is up to date"
else
    status="outdated"
    message="󰚰 Nixpkgs"
    description="New nixpkgs revision available"
fi

tooltip=$(printf '%s\nBranch: %s\nLocal: %.12s\nRemote: %.12s\nChecked: %s' \
    "$description" "$branch" "$local_rev" "$remote_rev" \
    "$(date '+%Y-%m-%d %H:%M')")

jq -cn \
    --arg status "$status" \
    --arg message "$message" \
    --arg tooltip "$tooltip" \
    --arg local_rev "$local_rev" \
    '{
        text: $message,
        tooltip: $tooltip,
        class: $status,
        local_rev: $local_rev
    }' > "$CACHE"

printf '%s\n' "$now" > "$STAMP"

jq -c '{text, tooltip, class}' "$CACHE"


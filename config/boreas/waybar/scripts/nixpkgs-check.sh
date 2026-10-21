
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

# Ensure the lock file exists.
if [[ ! -f "$LOCK" ]]; then
    show_status "error" "󰅚 Nixpkgs" \
        "flake.lock not found: $LOCK"
    exit 0
fi

# Read the locally locked nixpkgs revision.
local_rev=$(jq -r \
    '.nodes.nixpkgs.locked.rev // empty' "$LOCK")

branch=$(jq -r \
    '.nodes.nixpkgs.original.ref // empty' "$LOCK")

repo=$(jq -r \
    '.nodes.nixpkgs.original.repo // empty' "$LOCK")

owner=$(jq -r \
    '.nodes.nixpkgs.original.owner // empty' "$LOCK")

# Validate the configured input.
if [[ ! "$local_rev" =~ ^[0-9a-f]{40}$ ||
      -z "$branch" ||
      -z "$repo" ||
      -z "$owner" ]]; then

    show_status "error" "󰅚 Nixpkgs" \
        "Unsupported or invalid nixpkgs input"
    exit 0
fi

now=$(date +%s)

# Reuse cached results if:
#  - The cache is less than 24 hours old.
#  - The local nixpkgs revision has not changed.
#  - A forced refresh was not requested.
if [[ "${1:-}" != "--force" &&
      -f "$STAMP" &&
      -f "$CACHE" ]]; then

    checked=$(cat "$STAMP")
    cached_rev=$(jq -r \
        '.local_rev // empty' "$CACHE" 2>/dev/null)

    if [[ "$checked" =~ ^[0-9]+$ ]] &&
       (( now >= checked && now - checked < TTL )) &&
       [[ "$cached_rev" == "$local_rev" ]]; then

        jq -c '{text, tooltip, class}' "$CACHE"
        exit 0
    fi
fi

# Query the remote Git reference without cloning.
remote_rev=$(
    git ls-remote --exit-code \
        "https://github.com/$owner/$repo.git" \
        "refs/heads/$branch" 2>/dev/null |
    awk '{print $1}'
) || remote_rev=""

# Validate the remote result.
if [[ ! "$remote_rev" =~ ^[0-9a-f]{40}$ ]]; then
    show_status "error" "󰅚 Nixpkgs" \
        "Unable to retrieve remote revision for $branch"
    exit 0
fi

# Compare the local and remote revisions.
if [[ "$local_rev" == "$remote_rev" ]]; then
    status="updated"
    message="󰄬 Nixpkgs"
    description="nixpkgs is up to date"
    update_cmd=""
else
    status="outdated"
    message="󰚰 Nixpkgs"
    description="New nixpkgs revision available"
    update_cmd="nix flake update nixpkgs"
fi

# Build tooltip.
tooltip=$(printf \
    '%s\nBranch: %s\nLocal: %.12s\nRemote: %.12s\nChecked: %s' \
    "$description" \
    "$branch" \
    "$local_rev" \
    "$remote_rev" \
    "$(date '+%Y-%m-%d %H:%M')")

# Include the update command only when an update is available.
if [[ -n "$update_cmd" ]]; then
    tooltip+=$'\n'
    tooltip+="Command: $update_cmd"
fi

# Cache the successful result.
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

# Output the fields understood by Waybar.
jq -c '{text, tooltip, class}' "$CACHE"


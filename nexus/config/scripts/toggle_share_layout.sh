#!/usr/bin/env bash

set -euo pipefail

workspace="screencast"

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/niri"
runtime_file="$config_dir/runtime/screencast.kdl"
runtime_tmp="${runtime_file}.tmp"

mkdir -p "$(dirname "$runtime_file")"
touch "$runtime_file"

workspace_json="$(
    niri msg --json workspaces |
        jq -c --arg name "$workspace" \
            '.[] | select(.name == $name)' |
        head -n 1
)"

enable_workspace() {
    cat > "$runtime_tmp" <<'EOF'
workspace "screencast" {
    // Replace this with your actual output.
    open-on-output "DP-3"

    layout {
        gaps 0

        center-focused-column "never"
        always-center-single-column false

        // 3840 × 1200 output:
        // central 1920 × 1080 screencast area.
        struts {
            left 960
            right 960
            top 60
            bottom 60
        }

        default-column-width {
            fixed 960
        }

        preset-column-widths {
            fixed 960
            fixed 1920
        }

        preset-window-heights {
            fixed 540
            fixed 1080
        }
    }
}
EOF

    mv "$runtime_tmp" "$runtime_file"

    # Wait until niri has loaded the workspace declaration.
    for _ in {1..40}; do
        if niri msg --json workspaces |
            jq -e --arg name "$workspace" \
                '.[] | select(.name == $name)' >/dev/null
        then
            niri msg action focus-workspace "$workspace"
            return
        fi

        sleep 0.05
    done

    printf 'The screencast workspace was not created.\n' >&2
    exit 1
}

disable_workspace() {
    local workspace_id
    local window_count
    local is_focused

    workspace_id="$(jq -r '.id' <<< "$workspace_json")"
    is_focused="$(jq -r '.is_focused' <<< "$workspace_json")"

    window_count="$(
        niri msg --json windows |
            jq --argjson workspace_id "$workspace_id" \
                '[.[] | select(.workspace_id == $workspace_id)] | length'
    )"

    if ((window_count > 0)); then
        printf \
            'Cannot remove workspace "%s": it still contains %d window(s).\n' \
            "$workspace" \
            "$window_count" >&2
        exit 1
    fi

    # Niri will not remove the workspace while it remains focused.
    if [[ "$is_focused" == "true" ]]; then
        niri msg action focus-workspace-previous
    fi

    # Atomically replace the included file with an empty configuration.
    : > "$runtime_tmp"
    mv "$runtime_tmp" "$runtime_file"
}

if [[ -n "$workspace_json" ]]; then
    disable_workspace
else
    enable_workspace
fi

#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
theme_dir="$HOME/.config/omarchy/themes/stark"
launcher_dir="$HOME/.config/quickshell/stark-launcher"
hypr_dir="$HOME/.config/hypr"
stamp=$(date +%Y%m%d-%H%M%S)

for command in omarchy quickshell rsync; do
    if ! command -v "$command" >/dev/null 2>&1; then
        printf 'Missing required command: %s\n' "$command" >&2
        exit 1
    fi
done

# Install the visual theme without copying the launcher tooling into the theme.
if [[ $repo_dir != "$theme_dir" ]]; then
    mkdir -p "$theme_dir"
    rsync -a --delete \
        --exclude='.git' \
        --exclude='launcher' \
        --exclude='integration' \
        --exclude='install.sh' \
        --exclude='install-from-github.sh' \
        --exclude='.gitignore' \
        "$repo_dir/" "$theme_dir/"
fi

mkdir -p "$launcher_dir" "$hypr_dir"
rsync -a --delete "$repo_dir/launcher/" "$launcher_dir/"

bindings="$hypr_dir/bindings.lua"
autostart="$hypr_dir/autostart.lua"
touch "$bindings" "$autostart"

if ! grep -Fq 'STARK ARC REACTOR MENUS' "$bindings"; then
    cp "$bindings" "$bindings.bak.stark-$stamp"
    printf '\n' >> "$bindings"
    sed "s|\$HOME|$HOME|g" "$repo_dir/integration/bindings.lua" >> "$bindings"
fi

if ! grep -Fq 'STARK ARC REACTOR AUTOSTART' "$autostart"; then
    cp "$autostart" "$autostart.bak.stark-$stamp"
    printf '\n' >> "$autostart"
    sed "s|\$HOME|$HOME|g" "$repo_dir/integration/autostart.lua" >> "$autostart"
fi

omarchy theme set stark
omarchy theme bg set "$theme_dir/backgrounds/Dropped Image.png"
quickshell -n -d -p "$launcher_dir"

if [[ -n ${HYPRLAND_INSTANCE_SIGNATURE:-} ]]; then
    hyprctl reload
fi

printf 'Stark Arc Reactor installed. Press Super + Alt + Space to open it.\n'

# Stark Arc Reactor for Omarchy

An Iron Man / JARVIS-inspired Omarchy theme with a custom Quickshell Arc
Reactor launcher.

## What it installs

- The Stark color theme and bundled wallpapers.
- The Arc Reactor application launcher on `Super + Alt + Space`.
- A Stark command menu on `Super + Space`.
- A Stark system menu on `Super + Escape`.
- A resident Quickshell launcher for fast opening.

The installer copies only the launcher and the small Stark-specific Hyprland
overrides. It backs up `bindings.lua` and `autostart.lua` before changing them.

## Install

After this repository is published, install everything with one command:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/vlallen544/omarchy-stark-theme/main/install-from-github.sh)
```

Or clone it first so you can inspect the files before running the installer:

```bash
git clone https://github.com/vlallen544/omarchy-stark-theme.git
cd omarchy-stark-theme
./install.sh
```

The launcher is installed under `~/.config/quickshell/stark-launcher`. Restart
your session if you want its background process to start automatically now;
otherwise it will be ready after your next login.

## Keyboard shortcuts

| Shortcut | Menu |
| --- | --- |
| `Super + Alt + Space` | Searchable Arc Reactor app launcher |
| `Super + Space` | Command menu |
| `Super + Escape` | System menu |

## Theme-only installation

For only the visual theme, Omarchy can clone it directly:

```bash
omarchy theme install https://github.com/vlallen544/omarchy-stark-theme.git
```

Run `./install.sh` afterwards if you also want the Arc Reactor launcher and
its keybindings. Omarchy intentionally does not apply executable Lua from
themes downloaded from Git repositories.

## Credits

Built for Omarchy and Quickshell. Please open an issue or a pull request if
you improve the launcher or add a compatible wallpaper.

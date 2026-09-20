-- STARK ARC REACTOR MENUS
-- Installed by omarchy-stark-theme/install.sh
hl.unbind("SUPER + ALT + SPACE")
o.bind(
    "SUPER + ALT + SPACE",
    "Stark Arc Reactor",
    "sh -c 'quickshell ipc -p \"$HOME/.config/quickshell/stark-launcher\" call stark-launcher open apps || (quickshell -n -d -p \"$HOME/.config/quickshell/stark-launcher\"; sleep 0.15; quickshell ipc -p \"$HOME/.config/quickshell/stark-launcher\" call stark-launcher open apps)'"
)

hl.unbind("SUPER + SPACE")
o.bind(
    "SUPER + SPACE",
    "Stark command menu",
    "sh -c 'quickshell ipc -p \"$HOME/.config/quickshell/stark-launcher\" call stark-launcher open root || (quickshell -n -d -p \"$HOME/.config/quickshell/stark-launcher\"; sleep 0.15; quickshell ipc -p \"$HOME/.config/quickshell/stark-launcher\" call stark-launcher open root)'"
)

hl.unbind("SUPER + ESCAPE")
o.bind(
    "SUPER + ESCAPE",
    "Stark system menu",
    "sh -c 'quickshell ipc -p \"$HOME/.config/quickshell/stark-launcher\" call stark-launcher open system || (quickshell -n -d -p \"$HOME/.config/quickshell/stark-launcher\"; sleep 0.15; quickshell ipc -p \"$HOME/.config/quickshell/stark-launcher\" call stark-launcher open system)'"
)

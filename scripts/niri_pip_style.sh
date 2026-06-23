#!/bin/bash
# Toggle between: (1) floating PiP-style at top-right, (2) tiled at 0.5 proportion

IS_FLOATING=$(niri msg focused-window 2>/dev/null | grep "Is floating:" | awk '{print $3}')

if [ "$IS_FLOATING" = "yes" ]; then
    niri msg action move-window-to-tiling
    niri msg action set-column-width 50%
    niri msg action set-window-width 50%
else
    niri msg action move-window-to-floating
    niri msg action set-window-width 25%
    niri msg action set-window-height 25.5%
    niri msg action move-floating-window -x "75%" -y "0%"
    niri msg action move-floating-window -x "-3" -y "+3"
fi

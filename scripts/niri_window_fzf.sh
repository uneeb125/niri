#!/bin/bash

niri msg --json windows | jq -r '.[] | "\(.id)\t\(.title)\t\(.app_id)\t\(.pid)\t\(.is_focused)\t\(.is_floating)"' | \
  fzf --preview '~/.config/niri/scripts/niri-window-preview {1} {2} {3} {4} {5} {6}' \
     --preview-window=right,50% | \
  cut -d'	' -f1 | xargs -I{} niri msg action focus-window --id {}

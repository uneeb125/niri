#!/bin/bash

focused_id=$(niri msg --json windows | jq -r '.[] | select(.is_focused == true) | .id')

kitty --class fzpicker sh -c "
  focused_id=$focused_id

  get_picker_id() {
    niri msg --json windows | jq -r '[.[] | select(.app_id == \"fzpicker\")] | sort_by(-(.focus_timestamp.secs + .focus_timestamp.nanos / 1e9)) | first | .id // empty'
  }

  sleep 0.1
  picker_id=\$(get_picker_id)
  niri-float-sticky -app-id 'fzpicker' -ipc set_sticky 2>/dev/null

  peek() {
    niri msg action focus-window --id \"\$1\" 2>/dev/null
    sleep 0.08
    niri msg action focus-window --id \"\$2\" 2>/dev/null
  }
  export -f peek

  niri msg --json windows | jq -r '
    sort_by(.is_focused == true) | reverse | .[] |
    \"\\(.id)\\t\\(.app_id)\\t\\(.title)\\tws\\(.workspace_id)\\(if .is_floating then \" float\" else \"\" end)\"
  ' | fzf \
    --delimiter '\\t' \
    --with-nth 2.. \
    --no-multi \
    --preview '
      id={1}
      niri msg --json windows | jq -r --arg id \"\$id\" \"
        .[] | select(.id == (\\\$id | tonumber)) |
        \\\"App:     \\(.app_id)
PID:      \\(.pid)
Window:   \\(.id)
Workspace \\(.workspace_id)  \\(if .is_floating then \\\"floating\\\" else \\\"tiling\\\" end)
\\(if .is_focused then \\\"* focused\\\" else \\\"\\\" end)\\\"\"
    ' \
    --preview-window=right,35%,wrap \
    --bind \"focus:execute-silent(peek {1} \${picker_id})\" \
    --bind \"esc:execute-silent(niri msg action focus-window --id \${focused_id})+abort\" \
    --bind 'enter:execute-silent(niri msg action focus-window --id {1})+abort' \
    --header='Enter: focus | Esc: cancel'
"

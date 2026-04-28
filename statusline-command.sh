#!/bin/sh
input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // ""')
home="$HOME"
short_cwd=$(echo "$cwd" | sed "s|^$home|~|")
model=$(echo "$input" | jq -r '.model.display_name // ""')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$used" ]; then
  printf "%s  %s  ctx:%s%%" "$short_cwd" "$model" "$(printf '%.0f' "$used")"
else
  printf "%s  %s" "$short_cwd" "$model"
fi

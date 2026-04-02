#!/bin/bash

# Read stdin JSON
input=$(cat)

# Extract model name
model=$(echo "$input" | jq -r '.model.display_name')

# Extract context usage percentage
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Build status line
if [ -n "$used" ]; then
    # Calculate progress bar (20 characters wide)
    bar_width=20
    filled=$(printf "%.0f" "$(echo "$used / 5" | bc -l)")
    [ "$filled" -gt "$bar_width" ] && filled=$bar_width
    empty=$((bar_width - filled))
    
    # Build bar with filled and empty portions
    bar="["
    [ "$filled" -gt 0 ] && bar="${bar}$(printf '█%.0s' $(seq 1 $filled))"
    [ "$empty" -gt 0 ] && bar="${bar}$(printf '░%.0s' $(seq 1 $empty))"
    bar="${bar}]"
    
    # Format percentage
    used_fmt=$(printf "%.1f" "$used")

    # Color based on usage: green <45%, orange <70%, red >=70%
    if (( $(echo "$used < 45" | bc -l) )); then
        color="\033[32m"  # green
    elif (( $(echo "$used < 70" | bc -l) )); then
        color="\033[33m"  # orange/yellow
    else
        color="\033[31m"  # red
    fi
    reset="\033[0m"

    printf "%s │ Context: ${color}%s %s%%${reset}" "$model" "$bar" "$used_fmt"
else
    printf "%s" "$model"
fi

#!/bin/bash

# Read input once to avoid multiple subshells
input=$(cat)

# -------------------------------
# Colors
# -------------------------------
RESET="\033[0m"
CYAN="\033[36m"
BLUE="\033[34m"
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
MAGENTA="\033[35m"

# -------------------------------
# Extract JSON data
# -------------------------------
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // "."')
current_dir=$(basename "$cwd")

# -------------------------------
# MODEL (handles OpenRouter etc.)
# -------------------------------
model=$(echo "$input" | jq -r '
  (.model.display_name // .model.id // .model) //
  "unknown"
')

model=$(echo "$model" | sed -E 's@anthropic/@@; s@openrouter/@@')

# UPDATED: More robust token extraction paths
input_tokens=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // .usage.input_tokens // 0')
cache_creation=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // .usage.cache_creation_input_tokens // 0')
cache_read=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // .usage.cache_read_input_tokens // 0')
context_window_size=$(echo "$input" | jq -r '.context_window.context_window_size // .max_tokens // 200000')

# -------------------------------
# Git info
# -------------------------------
git_info=""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
    branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
    if [ -n "$branch" ]; then
        if [ -n "$(git -C "$cwd" status --porcelain 2>/dev/null)" ]; then
            git_info="($branch)✗"
        else
            git_info="($branch)"
        fi
    fi
fi

make_bar() {
    local percent=$1
    local width=20

    local filled=$((percent * width / 100))
    local empty=$((width - filled))

    printf "["
    for ((i = 0; i < filled; i++)); do printf "█"; done
    for ((i = 0; i < empty; i++)); do printf "░"; done
    printf "]"
}

# -------------------------------
# Context usage
# -------------------------------
context_info=""
ctx_color=$RESET # Default initialization

total_input=$((input_tokens + cache_creation + cache_read))

if [ "$total_input" -gt 0 ]; then
    percentage=$((total_input * 100 / context_window_size))

    # Scale to display k (thousands)
    input_k=$((total_input / 1000))
    window_k=$((context_window_size / 1000))

    bar=$(make_bar "$percentage")

    if [ "$percentage" -lt 50 ]; then
        ctx_color=$GREEN
    elif [ "$percentage" -lt 80 ]; then
        ctx_color=$YELLOW
    else
        ctx_color=$RED
    fi

    context_info="${bar} ${input_k}k/${window_k}k (${percentage}%)"
fi

# -------------------------------
# Output
# -------------------------------
printf "${CYAN}%s${RESET}" "$current_dir"
[ -n "$git_info" ] && printf " ${BLUE}%s${RESET}" "$git_info"
printf " ${MAGENTA}[%s]${RESET}" "$model"
[ -n "$context_info" ] && printf " ${ctx_color}%s${RESET}" "$context_info"
printf "\n"

#!/bin/bash

DIRS=("$HOME/apps" "$HOME/Apps" "$HOME/Applications")

declare -A APP_MAP
MENU=""

for dir in "${DIRS[@]}"; do
    [ -d "$dir" ] || continue
    
    while IFS= read -r app; do
        if [[ -L "$app" && -d "$app" ]]; then
            continue
        fi

        filename=$(basename "$app")
        # Truncate at first occurrence of ., _, -, or +
        shortname="${filename%%[._+-]*}"
        # Fallback if shortname is empty
        if [[ -z "$shortname" ]]; then
            shortname="$filename"
        fi

        # Capitalize every word if spaces exist, else capitalize first letter
        if [[ "$shortname" == *" "* ]]; then
            display_name=$(echo "$shortname" | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)} 1')
        else
            display_name="${shortname^}"
        fi

        # Trim whitespace and add only non-empty display names
        display_name_trimmed=$(echo "$display_name" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        if [[ -n "$display_name_trimmed" ]]; then
            APP_MAP["$display_name_trimmed"]="$app"
            MENU+="$display_name_trimmed"$'\n'
        fi
    done < <(find "$dir" -maxdepth 1 \( -type f -o -type l \) -executable ! -name ".*")
done

selected=$(echo "$MENU" | grep -v '^[[:space:]]*$' | sort -u | wofi --dmenu -i -p "Select Application:")

if [[ -n "$selected" && -f "${APP_MAP[$selected]}" ]]; then
    chmod +x "${APP_MAP[$selected]}"
    exec "${APP_MAP[$selected]}"
else
    echo "App not found or canceled."
fi


#!/bin/bash

# Fetch latest clipboard content
latest_clip=$(xclip -o -selection clipboard)

# Create a temporary file for clipboard history
tmpfile=$(mktemp /tmp/clipboard_history.XXXXXX)

# Append latest clipboard content to temporary file
echo "$latest_clip" >> "$tmpfile"

# Display clipboard history using dmenu and select an entry
selected_clip=$(cat "$tmpfile" | dmenu -l 10 -p "Clipboard:")

# Set selected content back to clipboard
echo -n "$selected_clip" | xclip -selection clipboard

# Clean up temporary file
rm "$tmpfile"

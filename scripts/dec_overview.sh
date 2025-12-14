#!/bin/sh

# Use the first command-line argument ($1) as the increment.
# Default to 0.1 if no argument is provided.
INCREMENT="-0.1" 
FILE="$HOME/.config/niri/overview.kdl" 

# Check if the file exists before proceeding
if [ ! -f "$FILE" ]; then
    echo "Error: File not found at $FILE" >&2
    exit 1
fi

# The core command:
# 1. Calculates the new value.
# 2. Uses a ternary operator to set the new value to 0.0 if the calculated value is negative.
gawk -i inplace -v incr="$INCREMENT" '
    /zoom/ {
        # Check if $2 is a number before incrementing
        if ($2 ~ /^[0-9.]*$/) {
            # Calculate the potential new value
            new_val = $2 + incr
            
            # Use 0.0 if new_val is less than 0, otherwise use new_val
            $2 = (new_val < 0.1) ? 0.1 : new_val
        }
    } 
    1
' "$FILE"

# Optional: Output the new zoom value for confirmation
NEW_ZOOM=$(gawk '/zoom/ { print $2 }' "$FILE")
echo "Updated $FILE: incremented by $INCREMENT. New zoom: $NEW_ZOOM"

#!/bin/bash
generate_string() {
    head --lines=3 /dev/urandom | tr -cd '[:print:]' | tr -s '\\ \"/!' 'pwkyx' | tr -s "'" "b" 
}

defined_string=$(generate_string)

# Check if an argument is provided
if [ "$#" -eq 0 ]; then
    # If no argument is provided, print the whole string
    echo "$defined_string"
elif [ "$#" -eq 1 ]; then
    # If exactly one argument is provided, use cut to extract the desired number of characters
    num_chars=$1
    # Ensure the number of characters is within the length of the defined string
    if [ "$num_chars" -le "${#defined_string}" ]; then
        echo "$defined_string" | cut -c1-"$num_chars"
    else
        echo "Error: Number of characters exceeds the length of the string."
        exit 1
    fi
else
    # If more than one argument is provided, print usage instructions
    echo "Usage: $0 [<number_of_characters>]"
    exit 1
fi


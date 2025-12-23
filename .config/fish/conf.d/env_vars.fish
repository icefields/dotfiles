set shell_env_path ~/.shell_env

function load_shell_env
    # Check if the file exists
    if test -f $shell_env_path
        sleep 1
        # Read the file line by line
        for line in (cat $shell_env_path)
            # Trim whitespace from the line
            set line (string trim $line)

            # Skip empty lines or comment lines
            if test -z "$line"
                continue
            end

            if string match -q -r "^#" $line
                continue
            end
      
            # Match the pattern KEY="quoted value"
            if string match -q -r '^\S+=".*"$' $line
                # Extract the key and value by splitting at the first '='
                set key (string split "=" $line | head -n 1)
                set value (string split "=" $line | tail -n 1)

                # Remove the surrounding quotes and trim spaces
                set value (string replace -r '^"(.*)"$' '$1' $value)
                set value (string trim $value)

                # Debug: Print the key and value being set (to check trimming)
                echo "Setting: $key = $value"

                # Set the variable globally in Fish
                set -gx $key $value
            else
                # Print a warning if the line doesn't match format
                echo "Warning: Invalid line skipped (does not match format): $line"
            end
        end
    else
        echo "Error: $shell_env_path does not exist"
    end
end

load_shell_env

#for key in (set -n)
#    echo "$key = (eval echo \$$key)"
#end


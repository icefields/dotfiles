from xonsh.built_ins import XSH
import os
import re

shell_env_path = Paths.ENV_VARS

def load_shell_env():
    if shell_env_path.exists():  # Path method
        with shell_env_path.open() as file:
            for line in file:
                line = line.strip()  # Remove any leading/trailing whitespace
                
                # Skip empty lines or comments
                if not line or line.startswith("#"):
                    continue
                
                # Regular expression to match KEY="quoted value"
                match = re.match(r'(\S+)\s*=\s*"([^"]*)"', line)
                if match:
                    key = match.group(1)  # This is the key (left side of `=`)
                    value = match.group(2)  # This is the value inside the quotes
                    
                    # Assign the variable to Xonsh environment
                    XSH.env[key] = value
                else:
                    print(f"Warning: Invalid line skipped (unquoted value or bad format): {line}")
    # Optional: copy macos/xonsh/shell_env.example to this path when you need secrets/API URLs.


load_shell_env()

#print("Loaded environment variables:")
#for key in XSH.env:
#    print(f"{key} = {XSH.env[key]}")


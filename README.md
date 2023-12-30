# Dot Files Backup
## Fish
Fish configuration files and functions.
## Bash
Bash config files (`.bashrc`)
## Vim and NeoVim
Vim and NeoVim configuration files.
## Kitty
In the advanced section of kitty.conf, the option `shell` is set to `/opt/default_shell-kitty_config` which is a link that points to the default shell. Create that link in your system before using Kitty.
ie. if the default shell is **Fish**, on Linux:
```
ln -s /opt/homebrew/bin/fish /opt/default_shell-kitty_config 
```
ie. if the default shell is **Bash**, on Linux:
```
ln -s /opt/homebrew/bin/fish /opt/default_shell-kitty_config 
```
ie. if the default shell is **Fish**, on MacOs:
```
ln -s /opt/homebrew/bin/fish /opt/default_shell-kitty_config 
```

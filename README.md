<!-- ![luci4-ascii](https://github.com/user-attachments/assets/b1b97840-3a3d-4b1a-aae1-5d86d7bc9024) -->
# Dot Files Luci4
![image](https://github.com/user-attachments/assets/b33396c0-0abd-46b7-9db8-9aa6e87789fb)

## Fish
Fish configuration files and functions.

### Functions:
<b>tari</b> - Compresses files and directories <br>
examples: <br>
`tari file.txt`<br>
`tari dir-name/`<br>
Result: files and dirs are compressed into file.txt.tar.gz, dir-name.tar.gz<br>

<b>tarx</b> - De-compresses files and directories, same as `tar -zxvf` <br>
examples: <br>
`tarx file.tar.gz`<br>

<b>backup</b> - Function for creating a backup file <br>
examples: <br>
`backup file.txt`<br>
Result: copies file as file.txt.bak <br>

<b>fcd</b> - Navigate to directory directly, if more dirs match the name, a list is provided for selection <br>
examples: <br>
`fcd luci4`<br>
Result: navigates to the directory called luci4, wherever it is <br>

<b>passgen</b> - Generate a random password <br>
examples: <br>
`passgen 32`<br>
Result: generates a 32-character password <br>

<b>getpath</b> - Finds a path and copies to clipboard <br>
examples: <br>
`getpath somepath`<br>

<b>tree</b> - Shows a tree view of the specified depth <br>
examples: <br>
`tree 2`<br>
Result: shows a tree view of the current directory, of depth 2 <br>


## Bash
Bash config files (`.bashrc`)

## Awesome WM
Requires all the autostarting apps to be installed, comment out, in `autorun.sh`, the apps that are not installed.<br>
<i>(incomplete) list of apps required by awesome scripts:</i> `i3lock nitrogen picom lxqt-policykit redshift-gtk xfce4-clipman xfce4-clipman xfce4-power-manager` <br>
`blueman-applet` comes with `blueman` package. `nm-applet` comes with `network-manager` <br><br>
Some of the widges from `awesome-wm-widgets` (https://github.com/streetturtle/awesome-wm-widgets) are used in the config.<br>
Requires Collision (https://github.com/Elv13/collision) for extended functionalities and shortcuts.<br>
Collision and awesome-wm-widgets to be cloned in the root awesome directory (`~/.config/awesome`)<br><br>
The directory `$HOME/apps` will be scanned for AppImages, which will be added to the menu. Keep your ***Standalone Applications and AppImages*** there, or edit the location in rc.lua.<br><br>
i3lock is used as the screensaver, `rc.lua` contains a shortcut to lock the screen that references to `lockscreen.sh` in the same directory.<br>
For new Arch installation install Blueman (double check the [Arch Wiki](https://wiki.archlinux.org/title/bluetooth) in case this info is outdated)<br>
Optionally, install and add `lxsession` (policy kit, polKit) to  the the autorun file.<br>
Check and edit `~/.config/awesome/screens.sh` according to your desired screen settings.<br>
Everything else included in the awesome config `rc.lua`, in the scripts in the same directory, and the subdirectories (ie. ./themes/..)
<br>
***share.sh*** will use dmenu to select a file and create a share link that will be copied to the clipboard. `xclip` and `dmenu` required. <br>
***scriy/sharesec.sh*** will allow the selection of multiple files, zip them, encrypt them if a password is passed, upload them and return a link (ie. for sharing) <br><br>
Add to (or create if it doesn't exist) `~/.config/awesome/autostart-custom.sh` applications to run at startup, on top of the ones that are already running by default (defined in `~/.config/awesome/autostart.sh` ).<br><br>
<b>Screen Resolution and scaling</b><br>
To customize the <b>screen resolution</b> add this line to `autostart-custom.sh`: `xrandr -s 1920x1080` .<br>
For scaling, create or edit `~/.Xresources` and add `Xft.dpi:148` (check https://dpi.lv for the right dpi value, you can use a multiple or fraction of that number) .

## Picom
This shouldn't have any requirements other than installing `picom`.
## Vim and NeoVim
***Check Vim and NeoVim configuration files headers and their own readme for more instructions.*** `.config/nvim/init.vim`

**SOURCES**<br>
https://github.com/junegunn/vim-plug/<br>
https://www.youtube.com/watch?v=JWReY93Vl6g<br>
https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions<br>

```
:PlugClean :PlugInstall :UpdateRemotePlugins
cocInstall, install manually coc-java, coc-python, coc-html, etc ...
instructions: https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions
:CocInstall coc-python
:CocInstall coc-clangd
:CocInstall coc-snippets
:CocCommand snippets.edit... FOR EACH FILE TYPE
```
install Python neovim<br>
`pip3 install pynvim`<br>
install node neovim<br>
`sudo npm install -g neovim`<br>

## Kitty
In the advanced section of kitty.conf, the option `shell` is set to `/opt/default_shell-kitty_config` which is a link that points to the default shell. Create that link in your system before using Kitty.
ie. if the default shell is **Fish**, on Linux:
```
ln -s $(which fish) /opt/default_shell-kitty_config 
```
ie. if the default shell is **Bash**, on Linux:
```
ln -s $(which bash) /opt/default_shell-kitty_config 
```
ie. if the default shell is **Fish**, on MacOs:
```
ln -s /opt/homebrew/bin/fish /opt/default_shell-kitty_config 
```
**Kitty font config**<br>
In the `kitty.config` specify a font that is not a nerd font, according to kitty's instructions.
Then download the Symbols only nerd font and set it up as a fallback font (all mappings are in kitty.config already, in this repo).
Use the test-fonts.sh script from the official nerd fonts repo to test<br>
`curl -JLO https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/bin/scripts/test-fonts.sh`<br>
More on kitty fonts: https://erwin.co/kitty-and-nerd-fonts/
<br>

# Bare Repository Instructions

## Initializing a bare repository for dot files
1 - init
```
git init --bare $HOME/.git-dotfiles
alias gitdots='/usr/bin/git --git-dir=$HOME/.git-dotfiles/ --work-tree=$HOME'
gitdots config --local status.showUntrackedFiles no
```
2 - Add the following aliases to `.bashrc` and `fish.config`
```
alias gitdots='/usr/bin/git --git-dir=$HOME/.git-dotfiles/ --work-tree=$HOME'
```
3 - Add files one by one to the repo and push. Other files in `$HOME` that are not tracked manually will not be tracked.
```
gitdots status
gitdots add .vimrc
gitdots commit -m "Add vimrc"
gitdots add .bashrc
gitdots commit -m "Add bashrc"
gitdots push
```

## Migrating/Restoring dot files
Source repository should ignore the folder where you'll clone it, so that you don't create weird recursion problems:
```
echo ".git-dotfiles" >> .gitignore
```
clone your dotfiles into a bare repository in a "dot" folder of your $HOME:
```
git clone --bare git@github.com:icefields/dotfiles.git $HOME/.git-dotfiles
```
Define the alias in the current shell scope:
*see step 2 - Add to `.bashrc` and `fish.config`*

Checkout the actual content from the bare repository to your $HOME:
```
gitdots checkout
```

The step above might fail with a message like:
```
error: The following untracked working tree files would be overwritten by checkout:
    .bashrc
    .gitignore
Please move or remove them before you can switch branches.
Aborting
```

This is because your `$HOME` folder might already have some stock configuration files which would be overwritten by Git. The solution is simple: back up the files if you care about them, remove them if you don't care. I provide you with a possible rough shortcut to move all the offending files automatically to a backup folder:

```
mkdir -p .config-backup && \
gitdots checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} .config-backup/{}
```

Re-run the check out if you had problems:
```
gitdots checkout
```

Set the flag showUntrackedFiles to no on this specific (local) repository (same as ):
```
gitdots config --local status.showUntrackedFiles no
```

You're done, from now on you can now type config commands to add and update your dotfiles:
*see step *3 - Add files one by one to the repo and push. Other files in `$HOME` that are not tracked manually will not be tracked.**

# Power Management
No power Management application is really required, just configure `/etc/systemd/logind.conf` appropriately
<br>
`sleep-manager.sh` launched from hyprland.conf with `exec-once = ~/.config/hypr/sleep-manager.sh` is going to take care of locking the machine after a timeout.
<br>
<br>
Simple version (no action for power button, ideal on macbook with Asahi Linux):
```
[Login]
# Power button press [ignore, poweroff, reboot, suspend]
HandlePowerKey=ignore
# Handle suspend key press
HandleSuspendKey=suspend  # Suspend the system (sleep)

# Handle hibernate key press
HandleHibernateKey=ignore  # Hibernate the system
HandleLidSwitch=suspend
```
More:
```
[Login]
IdleAction=suspend
IdleActionSec=32min
HandleLidSwitch=suspend
HandlePowerKey=suspend #poweroff
HandleSleepKey=suspend

# Controls whether the lid switch should be ignored if an inhibition is in place.
# Value: no means the lid switch will not be ignored if an application or service has inhibited power-saving actions. The system will still respond to the lid switch event even if an application has requested to prevent power-saving actions.
LidSwitchIgnoreInhibited=no

# Controls what action the system should take when the lid is closed while the laptop is docked or connected to external monitors.
# Value: ignore means the system will ignore the lid switch event when docked, so closing the lid will not trigger any action.
HandleLidSwitchDocked=ignore

# Controls the maximum delay before the system honors an inhibition request, which prevents actions like suspension or hibernation.
# Value: 1800 means the system will wait up to 30 minutes before checking if any inhibition requests are in place.
InhibitDelayMaxSec=1600
```

# Applications (Hyprland)
<b>files browser:</b>
thunar <br>
<b>text editor:</b>
nvim
`sudo ln -s $(which kitty) /usr/bin/gnome-terminal` so thunar will open text files in nvim
<br>
<b>dmenu</b> is replaced by wofi in Wayland, to allow scripts that rely on dmenu to work:<br>
`sudo ln -s /home/luci/.config/wofi/dmenu.sh /usr/bin/dmenu`<br>

# Fonts
<b>Awesome:</b>
```
UbuntuSansMono Nerd Font Mono Medium
UbuntuSansMono Nerd Font Mono
UbuntuSansMono Nerd Font Mono SemiBold
```
<b>Kitty:</b>
```
Fira Code
Fira Code Medium
Fira Code Italic
Symbols only nerd font
```
<b>Other Fonts:</b>
```
Inter
```

# Wallpapers
Wallpapers are in `Pictures/wallpapers`. <br>
There are scripts in place to automate the process. Follow this initial setup to get started.
### Hyprland Instructions
create the following symlinks: <br>
`link -> original file` <br>
`/usr/share/hyprland/wall0.png -> $HOME/.config/hypr/wallpapers/wall0.png` <br> 
`/usr/share/hyprland/wall1.png -> $HOME/.config/hypr/wallpapers/wall1.png` <br>
`/usr/share/hyprland/wall2.png -> $HOME/.config/hypr/wallpapers/wall2.png` <br>

symlink or copy the images to use as wallpapers, one by one, into `.config/hypr/wallpapers/`.

### Awesome Instructions
symlink or copy the images to use as wallpapers, one by one, into `.config/awesome/themes/luci4/wallpapers/`.

# Other Applications (incomplete)
The launchers for applications required by scripts should be located under: `$HOME/apps`, `$HOME/.config/awesome`<br>
also check `$HOME/.config/awesome/autostart.sh`, and the bottom of `$HOME/.config/awesome/rc.lua`

| app | required by | note |
| --- | --- | --- |
| fastfetch | kitty |https://github.com/fastfetch-cli/fastfetch/releases/ |
| lolcat | kitty | package manager |
| bat / batcat | fish | package manager |
| eza | fish | package manager |
| python3-pynvim | neovim | package manager |
| npm | neovim | sudo npm install -g neovim |
| xclip | fish, awesome | |
| wl-copy | fish, hyprland | |
| fzf | fish, hyprland, awesome | package manager |
| distrobox | hyprland, awesome | package manager |

## pacman config
located at `/etc/pacman.conf`
<br>
Under "misc options" add:
```
# Misc options
Color
ILoveCandy

ParallelDownloads = 5
```

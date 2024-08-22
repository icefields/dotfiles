```
   ▄        ▄     ▄  ▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄  ▄     ▄ 
  ▐░▌      ▐░▌   ▐░▌▐░█▀▀▀▀▀  ▀▀█░█▀▀ ▐░▌   ▐░▌
  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌   ▐░█   █░▌
  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌   ▐░░░░░░░▌
  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌    ▀▀▀▀▀█░▌
  ▐░█▄▄▄▄▄ ▐░█▄▄▄█░▌▐░█▄▄▄▄▄  ▄▄█░█▄▄       ▐░▌
   ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀        ▀ 
                                                                 
```

# Dot Files Backup
## Fish
Fish configuration files and functions.
## Bash
Bash config files (`.bashrc`)
## Awesome WM
Requires all the autostarting apps to be installed, comment out, in `autorun.sh`, the apps that are not installed.<br>
Some of the widges from `awesome-wm-widgets` (https://github.com/streetturtle/awesome-wm-widgets) are used in the config.<br>
Requires Collision (https://github.com/Elv13/collision) for extended functionalities and shortcuts.<br>
Collision and awesome-wm-widgets to be cloned in the root awesome directory (`~/.config/awesome`)<br>
The directory `$HOME/apps` will be scanned for AppImages, which will be added to the menu. Keep your ***Standalone Applications and AppImages*** there, or edit the location in rc.lua.<br>
i3lock is used as the screensaver, `rc.lua` contains a shortcut to lock the screen that references to `lockscreen.sh` in the same directory.<br>
For new Arch installation install Blueman (double check the [Arch Wiki](https://wiki.archlinux.org/title/bluetooth) in case this info is outdated)<br>
Optionally, install and add `lxsession` (policy kit, polKit) to  the the autorun file.<br>
Everything else included in the awesome config `rc.lua`, in the scripts in the same directory, and the subdirectories (ie. ./themes/..)
<br>
***share.sh*** will use dmenu to select a file and create a share link that will be copied to the clipboard. `xclip` and `dmenu` required. <br>
***scriy/sharesec.sh*** will allow the selection of multiple files, zip them, encrypt them if a password is passed, upload them and return a link (ie. for sharing) <br>
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

## Kitty
In the advanced section of kitty.conf, the option `shell` is set to `/opt/default_shell-kitty_config` which is a link that points to the default shell. Create that link in your system before using Kitty.
ie. if the default shell is **Fish**, on Linux:
```
ln -s /opt/homebrew/bin/fish /opt/default_shell-kitty_config 
```
ie. if the default shell is **Bash**, on Linux:
```
ln -s $(which fish) /opt/default_shell-kitty_config 
```
ie. if the default shell is **Fish**, on MacOs:
```
ln -s $(which fish) /opt/default_shell-kitty_config 
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
thunar
<b>text editor:</b>
nvim
`sudo ln -s $(which kitty) /usr/bin/gnome-terminal` so thunar will open text files in nvim

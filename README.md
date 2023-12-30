```
       _                   _ 
      | |                 (_)
      | |     _   _   ___  _ 
      | |    | | | | / __|| |
      | |____| |_| || (__ | |
      \_____/ \__,_| \___||_|
```

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

## NVIM Config
***Also check the header of the config file*** `.config/nvim/init.vim`

https://github.com/junegunn/vim-plug/wiki/tutorial
vim-plug, a modern Vim plugin manager, downloads plugins into separate directories for you and makes sure that they are loaded correctly. It allows you to easily update the plugins, review (and optionally revert) the changes, and remove the plugins that are no longer used.

vim-plug is distributed as a single Vimscript file. All you have to do is to download the file in a directory so that Vim can load it.

```
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```	
With vim-plug, you declare the list of plugins you want to use in your Vim configuration file. It's ~/.vimrc for ordinary Vim, and ~/.config/nvim/init.vim for Neovim. The list should start with call plug#begin(PLUGIN_DIRECTORY) and end with call plug#end(). PLUGIN_DIRECTORY is a placeholder for vim-plug's plugin directory. Please do not set it to a directory from runtimepath option. Do NOT set it to the autoload/ directory where plug.vim is.

### SOURCES
https://github.com/junegunn/vim-plug/
https://www.youtube.com/watch?v=JWReY93Vl6g
https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions

   ▄        ▄     ▄  ▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄  ▄     ▄ 
  ▐░▌      ▐░▌   ▐░▌▐░█▀▀▀▀▀  ▀▀█░█▀▀ ▐░▌   ▐░▌
  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌   ▐░█   █░▌
  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌   ▐░░░░░░░▌
  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌    ▀▀▀▀▀█░▌
  ▐░█▄▄▄▄▄ ▐░█▄▄▄█░▌▐░█▄▄▄▄▄  ▄▄█░█▄▄       ▐░▌
   ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀        ▀ 

```
:PlugClean :PlugInstall :UpdateRemotePlugins
cocInstall, install manually coc-java, coc-python, coc-html, etc ...
instructions: https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions
:CocInstall coc-python
:CocInstall coc-clangd
:CocInstall coc-snippets
:CocCommand snippets.edit... FOR EACH FILE TYPE
```

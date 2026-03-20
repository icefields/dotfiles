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
https://github.com/junegunn/vim-plug/<br>
https://www.youtube.com/watch?v=JWReY93Vl6g<br>
https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions<br>

```
   ▄        ▄     ▄  ▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄  ▄     ▄ 
  ▐░▌      ▐░▌   ▐░▌▐░█▀▀▀▀▀  ▀▀█░█▀▀ ▐░▌   ▐░▌
  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌   ▐░█   █░▌
  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌   ▐░░░░░░░▌
  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌    ▀▀▀▀▀█░▌
  ▐░█▄▄▄▄▄ ▐░█▄▄▄█░▌▐░█▄▄▄▄▄  ▄▄█░█▄▄       ▐░▌
   ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀        ▀ 
```

```
:PlugClean :PlugInstall :UpdateRemotePlugins
cocInstall, install manually coc-java, coc-python, coc-html, etc ...
instructions: https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions
:CocInstall coc-python
:CocInstall coc-clangd
:CocInstall coc-snippets
:CocCommand snippets.edit... FOR EACH FILE TYPE
```

<br>

#### To enable copy/paste in ssh
Add this at the bottom of init.vim or init.lua
```
set nocompatible

if exists('$SSH_TTY') || exists('$SSH_CONNECTION')
  lua << trim EOF
    vim.g.clipboard = {
      name = 'OSC 52',
      copy = {
        ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
        ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
      },
      paste = {
        ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
        ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
      },
    }
  EOF
endif

set clipboard=unnamedplus
```

Or, this worked on Ubuntu Server

```
" === PLUGINS ===
call plug#begin()
Plug 'ojroques/nvim-osc52'
call plug#end()

" === OSC 52 CLIPBOARD FOR SSH ===
if exists('$SSH_CONNECTION')
  lua << EOF
local function copy(lines, _)
  require('osc52').copy(table.concat(lines, '\n'))
end

local function paste()
  return {vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('')}
end

vim.g.clipboard = {
  name = 'osc52',
  copy = {['+'] = copy, ['*'] = copy},
  paste = {['+'] = paste, ['*'] = paste},
}
EOF
endif

set clipboard=unnamedplus
```


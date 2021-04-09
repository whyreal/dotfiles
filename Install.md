# dotfiles

```sh
git clone https://github.com/whyreal/dotfiles.git ~/code/whyreal/dotfiles

cd ~/.config
ln -s ~/code/whyreal/dotfiles/alacritty/ ./
ln -s ~/code/whyreal/dotfiles/fish/ ./
ln -s ~/code/whyreal/dotfiles/karabiner ./
ln -s ~/code/whyreal/dotfiles/vim ./

cd ~
ln -s ~/code/whyreal/dotfiles/hammerspoon ./.hammerspoon
ln -s ~/code/whyreal/dotfiles/_tmux.conf ./.tmux.conf
```

# Homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install lua lua@5.1 luajit luarocks
brew install fish
chsh -s /usr/local/bin/fish

brew install neovim wkhtmltopdf tree-sitter
brew install tmux reattach-to-user-namespace
brew install fd fzf dos2unix ripgrep tree watch wget nmap mtr mysql-client rar pwgen telnet arping readline rlwrap
brew install coreutils gnu-sed gawk

brew install hammerspoon karabiner-elements
```

# Lua

```sh
lua/lua5.1_deps_install.sh
```

# zlua
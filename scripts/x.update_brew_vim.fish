#!/usr/bin/env fish

x.proxy.active

brew upgrade
brew cleanup
nvim --headless "+Lazy! sync" +qa
nvim --headless +CocUpdateSync +qa
nvim --headless +TSUpdateSync +qa

x.proxy.deactive

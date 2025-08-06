#!/usr/bin/env fish

#x.proxy.active

brew upgrade
brew cleanup
#x.proxy.deactive

nvim --headless "+Lazy! sync" +qa
nvim --headless +CocUpdateSync +qa
nvim --headless +TSUpdateSync +qa

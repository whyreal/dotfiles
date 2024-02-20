function uppdate_brew_vim

brew upgrade
brew cleanup
nvim --headless "+Lazy! sync" +qa
nvim --headless +CocUpdateSync +qa
nvim --headless +TSUpdateSync +qa

end
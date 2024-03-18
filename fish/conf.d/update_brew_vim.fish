function update_brew_vim

proxy.ss.active

brew upgrade
brew cleanup
nvim --headless "+Lazy! sync" +qa
nvim --headless +CocUpdateSync +qa
nvim --headless +TSUpdateSync +qa

proxy.ss.deactive

end

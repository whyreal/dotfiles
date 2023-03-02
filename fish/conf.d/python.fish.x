# python
set -g fish_user_paths "$HOME/.local/bin/" $fish_user_paths

# pyenv https://github.com/pyenv/pyenv
set -Ux PYENV_ROOT $HOME/.pyenv
set -g fish_user_paths $PYENV_ROOT/bin $fish_user_paths
status is-login; and pyenv init --path | source
status is-interactive; and pyenv init - | source

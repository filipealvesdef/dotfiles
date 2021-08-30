export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
source /usr/share/nvm/init-nvm.sh
export PATH=$PATH:$HOME/.local/bin
export DOTFILES_PATH="$HOME/.dotfiles"
source "$DOTFILES_PATH/.config/pc_actions_handler/config"
source "$DOTFILES_PATH/.config/pysmarthome/config"

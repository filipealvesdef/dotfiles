# ssh agent
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
###################################################################

source /usr/share/nvm/init-nvm.sh
export PATH=$PATH:$HOME/.local/bin
export DOTFILES_PATH="$HOME/.dotfiles"

CONFIG_DIR="$HOME/.config"
TO_EXPORT=("broadlink" "yeelight" )
for dir in "${TO_EXPORT[@]}"; do
    CONFIG_PATH="$CONFIG_DIR/$dir/config"
    export $(grep -v '^#' $CONFIG_PATH | xargs)
done

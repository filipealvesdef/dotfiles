### If you try to export these variable on .zprofile, it won't work as expected
#
# WSL GUI
export HOST_ADDR=$(awk '/nameserver / {print $2}' /etc/resolv.conf)
export DISPLAY=$HOST_ADDR:0
export PULSE_SERVER=tcp:$HOST_ADDR
#
# ssh agent
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
###################################################################

source /usr/share/nvm/init-nvm.sh
export PATH=$PATH:$HOME/.local/bin
export DOTFILES_PATH="$HOME/.dotfiles"

CONFIG_DIR="$HOME/.config"
TO_EXPORT=("broadlink" "govee" "sonoff" "yeelight" )
for dir in "${TO_EXPORT[@]}"; do
    CONFIG_PATH="$CONFIG_DIR/$dir/config"
    export $(grep -v '^#' $CONFIG_PATH | xargs)
done

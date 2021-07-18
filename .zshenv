export HOST_ADDR=$(awk '/nameserver / {print $2}' /etc/resolv.conf)
export DISPLAY=$HOST_ADDR:0
export PULSE_SERVER=tcp:$HOST_ADDR

source /usr/share/nvm/init-nvm.sh
export PATH=$PATH:$HOME/.local/bin
export DOTFILES_PATH="$HOME/.dotfiles"

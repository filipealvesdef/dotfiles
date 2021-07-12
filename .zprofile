export FZF_DEFAULT_COMMAND='rg --files --follow --hidden --glob "!.git/*"'
zstyle ':completion:*:*:git:*' user-commands fixup:'Create a fixup commit'

export HOST_ADDR=$(awk '/nameserver / {print $2}' /etc/resolv.conf)
export DISPLAY=$HOST_ADDR:0
export PULSE_SERVER=tcp:$HOST_ADDR

source ~/.zplug/init.zsh

function bindings()
{
    bindkey '^J' clear-screen

    # Menu selection
    bindkey -M menuselect 'h' vi-backward-char
    bindkey -M menuselect 'k' vi-up-line-or-history
    bindkey -M menuselect 'l' vi-forward-char
    bindkey -M menuselect 'j' vi-down-line-or-history
    bindkey -M menuselect '^[' send-break

    # zvm
    zvm_bindkey vicmd '^[[H' beginning-of-line # home key
    zvm_bindkey viins '^[[H' beginning-of-line
    zvm_bindkey vicmd '^[[1~' beginning-of-line # it can have this code too
    zvm_bindkey viins '^[[1~' beginning-of-line
    zvm_bindkey viins '^A' beginning-of-line
    zvm_bindkey vicmd '^A' beginning-of-line

    zvm_bindkey vicmd '^[[4~' end-of-line # end key
    zvm_bindkey viins '^[[4~' end-of-line
    zvm_bindkey vicmd '^[[F' end-of-line # it can have this code too
    zvm_bindkey viins '^[[F' end-of-line
    zvm_bindkey viins '^E' end-of-line
    zvm_bindkey vicmd '^E' end-of-line

    # use the "vi" prefix to partial accept autosuggestions
    zvm_bindkey viins '^W' vi-forward-word
    zvm_bindkey vicmd '^W' vi-forward-word
    zvm_bindkey viins '^[[1;3C' vi-forward-word # alt + right arrow
    zvm_bindkey vicmd '^[[1;3C' vi-forward-word
    zvm_bindkey viins '^[[1;5C' vi-forward-word # ctrl + right arrow
    zvm_bindkey vicmd '^[[1;5C' vi-forward-word

    zvm_bindkey viins '^B' backward-word
    zvm_bindkey vicmd '^B' backward-word
    zvm_bindkey viins '^[[1;3D' backward-word # alt + left arrow
    zvm_bindkey vicmd '^[[1;3D' backward-word
    zvm_bindkey viins '^[[1;5D' backward-word # ctrl + left arrow
    zvm_bindkey vicmd '^[[1;5D' backward-word

    zvm_bindkey viins '^[[3~' delete-char # delete key
    zvm_bindkey vicmd '^[[3~' delete-char
    zvm_bindkey vicmd '^X' delete-char
    zvm_bindkey viins '^X' delete-char

    zvm_bindkey vicmd '^?' backward-delete-char # backspace key
    zvm_bindkey viins '^S' backward-delete-word
    zvm_bindkey vicmd '^S' backward-delete-word

    zvm_bindkey viins '^D' delete-word
    zvm_bindkey vicmd '^D' delete-word

    zvm_bindkey vicmd '^H' backward-char
    zvm_bindkey viins '^H' backward-char

    zvm_bindkey vicmd '^L' forward-char
    zvm_bindkey viins '^L' forward-char

    zvm_bindkey vicmd '^U' backward-kill-line
    zvm_bindkey vicmd '^K' kill-line

    zvm_bindkey viins '^Z' undo
    zvm_bindkey vicmd '^Z' undo
}

function prompt_git()
{
    local s='';
    local branchName='';

    # Check if the current directory is in a Git repository.
    git rev-parse --is-inside-work-tree &>/dev/null || return;

    # Check for what branch we’re on.
    # Get the short symbolic ref. If HEAD isn’t a symbolic ref, get a
    # tracking remote branch or tag. Otherwise, get the
    # short SHA for the latest commit, or give up.
    branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
	    git describe --all --exact-match HEAD 2> /dev/null || \
        git rev-parse --short HEAD 2> /dev/null || \
        echo '(unknown)')";

    # Early exit for Chromium & Blink repo, as the dirty check takes too long.
    # Thanks, @paulirish!
    # https://github.com/paulirish/dotfiles/blob/dd33151f/.bash_prompt#L110-L123
    repoUrl="$(git config --get remote.origin.url)";
    if grep -q 'chromium/src.git' <<< "${repoUrl}"; then
	    s+='*';
    else
	    # Check for uncommitted changes in the index.
        if ! $(git diff --quiet --ignore-submodules --cached); then
            s+='+';
        fi;
        # Check for unstaged changes.
        if ! $(git diff-files --quiet --ignore-submodules --); then
            s+='!';
        fi;
        # Check for untracked files.
        if [ -n "$(git ls-files --others --exclude-standard)" ]; then
            s+='?';
        fi;
        # Check for stashed files.
        if $(git rev-parse --verify refs/stash &>/dev/null); then
            s+='$';
        fi;
    fi;

    [ -n "${s}" ] && s=" [${s}]";

    echo -e "on %B%F{magenta}${branchName}%F{yellow}${s}%f%b";
}

function precmd()
{
    # Print a newline before the prompt, unless it's the first
    # prompt in the parent process.
    if [ -z "${NEWLINE_BEFORE_PROMPT+x}" ]; then
        NEWLINE_BEFORE_PROMPT=1
    else
      echo ""
    fi
}

function prompt_zvm()
{
    if [ "$ZVM_MODE" = "$ZVM_MODE_INSERT" ]; then
        echo "[i]"
    elif [ "$ZVM_MODE" = "$ZVM_MODE_NORMAL" ]; then
        echo "[n]"
    elif [ "$ZVM_MODE" = "$ZVM_MODE_VISUAL" ] || \
        [ "$ZVM_MODE" = "$ZVM_MODE_VISUAL_LINE" ]; then
        echo "[v]"
    elif [ "$ZVM_MODE" = "$ZVM_MODE_REPLACE" ]; then
        echo "[r]"
    fi
}

function zvm_after_init()
{
    # This will load fzf bindings after zvm plugin loads
    source /usr/share/fzf/key-bindings.zsh
    source /usr/share/fzf/completion.zsh
    bindings
}

stty -ixon # disables terminal "freezing" when press ctrl+s
br=$'\n'
setopt PROMPT_SUBST
PS1='%B%F{red}%n%f%b@%B%F{blue}%m%f%b in %B%F{cyan}%~%f%b $(prompt_git)${br}%B\
$(prompt_zvm)%f $%b '

# Plugins
zplug "jeffreytse/zsh-vi-mode"
zplug "unixorn/fzf-zsh-plugin"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug load

# zvm config
ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
ZVM_VI_EDITOR=nvim
ZVM_KEYTIMEOUT=0.1
ZVM_ESCAPE_KEYTIMEOUT=0.1

# completion
autoload -Uz compinit
compinit -i
zmodload -i zsh/complist
setopt auto_cd # cd by typing directory name if it's not a command
setopt auto_menu # automatically use menu completion
setopt always_to_end # move cursor to end if word had one match
zstyle ':completion:*' menu select # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion

# Aliases
alias grep='grep --color=auto'
alias less='less -R'
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias cls='unset NEWLINE_BEFORE_PROMPT && clear'
alias sdi3='systemd-start-i3'
alias tmux='tmux -2'
alias xclip='xclip -selection clipboard'

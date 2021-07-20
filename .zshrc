source ~/.zplug/init.zsh
br=$'\n'
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
}

PS1='%B%F{red}%n%f%b@%B%F{blue}%m%f%b in %B%F{cyan}%~%f%b $(prompt_git)${br}%B\
$(prompt_zvm)%f $%b '

# Plugins
zplug "plugins/git", from:oh-my-zsh
zplug "jeffreytse/zsh-vi-mode"
zplug "unixorn/fzf-zsh-plugin"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-completions"
zplug load

autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

autoload -Uz compinit
compinit -i
zmodload -i zsh/complist
setopt auto_cd # cd by typing directory name if it's not a command
setopt PROMPT_SUBST
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

# Keybindings
bindkey '^K' up-line-or-beginning-search
bindkey '^J' down-line-or-beginning-search
bindkey '^F' autosuggest-accept
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

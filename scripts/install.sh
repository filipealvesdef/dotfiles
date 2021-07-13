#!/usr/bin/sh
TMP_DIR="/tmp"
DOTFILES_DEFAULT_PATH="$HOME/dotfilessdfs"
DOTFILES_URL="https://github.com/filipealvesdef/dotfiles.git"
BACKUP_BASEDIR="$HOME/dotfiles-backup"
BACKUP_DIR="$BACKUP_BASEDIR/$(date +%s)"

### TPM  ###
TPM_DIR="$HOME/.tmux/plugins/tpm"
TPM_URL="https://github.com/tmux-plugins/tpm"

### YAY ###
YAY_URL="https://aur.archlinux.org/yay.git"
YAY_TMP_DIR="$TMP_DIR/yay"

### VIM PLUG ###
VIM_PLUG_LOADER_PATH="$HOME/.local/share/nvim/site/autoload/plug.vim"
VIM_PLUG_URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
NVIM_PLUGINS_PATH="$HOME/.local/share/nvim/plugged"

### POLYBAR_FORECAST ###
POLYBAR_FORECAST_PATH="/usr/bin/polybar-forecast"
POLYBAR_FORECAST_BIN_URL="https://github.com/kamek-pf/polybar-forecast/releases/download/v1.1.0/polybar-forecast-linux-x86_64"

### NVM ###
NVM_URL="https://github.com/nvm-sh/nvm.git"
NVM_DIR="${HOME}/.nvm"

### ZPLUG ###
ZPLUG_URL="https://raw.githubusercontent.com/zplug/installer/master/installer.zsh"
ZPLUG_PATH="$HOME/.zplug"

### GRUVBOX MATERIAL GTK ###
GRUVBOX_MATERIAL_GTK_URL="https://github.com/sainnhe/gruvbox-material-gtk.git"
GRUVBOX_MATERIAL_GTK_TMP_PATH="$TMP_DIR/gruvbox-material-gtk"
THEMES_PATH="/usr/share/themes"
THEME_NAME="Gruvbox-Material-Dark"

## PACKAGE LIST ###
PACMAN_FLAGS=("--noconfirm" "--noprogressbar" "--needed")
ROOT_PKGS=(base-devel git);
GENERAL_PKGS=(
    aws-cli-v2-bin
    chromium
    curl
    dbus-python # Required by polybar-now-playing
    docker
    feh
    firefox
    fzf
    git-fixup-git
    gtk3
    htop
    i3-gaps
    kitty
    mpd
    neofetch
    neovim
    nerd-fonts-fira-code
    nerd-fonts-hack
    nvidia
    papirus-icon-theme
    pavucontrol
    picom-jonaburg-git # picom fork with blur, transition and rounded borders
    playerctl
    polybar
    python
    python-pip
    ranger
    rofi
    sddm
    tig
    tmux
    ttf-font-awesome
    ttf-material-icons-git # Required by polybar forecast
    ttf-weather-icons # Required by polybar forecast
    unzip
    wget
    zsh
);

loading_animation () {
    while ps | grep $! &> /dev/null; do
        echo -n "."
        sleep 0.7
    done
}

clean_line () {
    echo -ne "\r\033[K\r"
}

print_row() {
    for i in {1..80}; do
        printf "-";
    done
    printf "\n";
}

tilde_path() {
    echo "$1" | sed s/${HOME//\//\\\/}/\~/
}

if [ "$1" == "--clean" ]; then
    echo "Cleaning up...";
    echo "Removing yay...";
    sudo pacman -R --noconfirm --noprogressbar yay &>/dev/null;

    echo "Removing themes...";
    sudo rm -rf $THEMES_PATH/$THEME_NAME*;
    sudo rm -rf $GRUVBOX_MATERIAL_GTK_TMP_PATH;

    echo "Removing Node version manager...";
    rm -rf $NVM_DIR;

    echo "Removing temux plugin manager...";
    rm -rf $TPM_DIR;

    echo "Removing z plug";
    rm -rf $ZPLUG_PATH;

    echo "Removing polybar forecast...";
    sudo rm $POLYBAR_FORECAST_PATH;

    echo "Removing neo vim pluggins...";
    rm -rf $NVIM_PLUGINS_PATH;

    printf "Removing vim-plug...";
    rm $VIM_PLUG_LOADER_PATH;
fi

### Root packages ###
echo -n "Installing root packages with pacman";
sudo pacman -S "${PACMAN_FLAGS[@]}" $ROOT_PKG &>/dev/null &
loading_animation
clean_line
printf "Root packages installed!"
clean_line

### yay ###
if ! yay --version &> /dev/null; then
    echo -n "Installing package manager helper (YAY)";
    [ -d "$YAY_TMP_DIR" ] && rm -rf $YAY_TMP_DIR;
    {
        git clone $YAY_URL $YAY_TMP_DIR && \
        cd "$YAY_TMP_DIR" && \
        makepkg -si "${PACMAN_FLAGS[@]}"
    } &>/dev/null &
    loading_animation
    cd - &> /dev/null && \
    rm -rf "$YAY_TMP_DIR";
    clean_line
    printf "Yay successfully installed";
    clean_line
fi

### General packages ###
echo -n "Syncing packages";
yay -S "${PACMAN_FLAGS[@]}" $GENERAL_PKGS &>/dev/null &
loading_animation
clean_line
printf "All packages were updated!\n"

### z-plug for managing zsh plugins###
if [ ! -d "$ZPLUG_PATH" ]; then
    printf "Installing zsh plugin manager (zplug)";
    /usr/bin/sh -c "curl -sL --proto-redir -all,https $ZPLUG_URL| zsh" &>/dev/null &
    loading_animation
    clean_line
    printf "z-plug installed!\n"
fi

### Vim-plug ###
if [ ! -f $VIM_PLUG_LOADER_PATH ]; then
    echo -n "Installing vim-plug";
    /usr/bin/sh -c "curl -fsLo $VIM_PLUG_LOADER_PATH --create-dirs \
        $VIM_PLUG_URL" &>/dev/null &
    loading_animation
    clean_line
    printf "Vim-Plug installed!\n"
fi

### Tmux plugin manager ###
if [ ! -d $TPM_DIR ]; then
    echo -n "Cloning TPM (tmux plugin manager)";
    /usr/bin/sh -c "git clone --quiet $TPM_URL $TPM_DIR" &>/dev/null &
    loading_animation
    clean_line
    printf "TPM installed!\n"
fi

### GTK theme ###
if [ ! -d "$THEMES_PATH/$THEME_NAME" ] && [ ! -d "$GRUVBOX_MATERIAL_GTK_TMP_PATH" ];
then
    echo -n "Installing $THEME_NAME into $THEMES_PATH/$THEME_NAME";
    sudo /usr/bin/sh -c "git clone --quiet "$GRUVBOX_MATERIAL_GTK_URL" \
        "$GRUVBOX_MATERIAL_GTK_TMP_PATH" && \
        mv "$GRUVBOX_MATERIAL_GTK_TMP_PATH/themes/*" "$THEMES_PATH" && \
        rm -rf $GRUVBOX_MATERIAL_GTK_TMP_PATH" &>/dev/null &
    loading_animation
    clean_line
    printf "$THEME_NAME installed!\n"
fi

### Polybar forecast ###
if [ ! -f $POLYBAR_FORECAST_PATH ]; then
    echo -n "Installing polybar forecast into $POLYBAR_FORECAST_PATH";
    /usr/bin/sh -c "sudo curl -fsLo $POLYBAR_FORECAST_PATH \
        $POLYBAR_FORECAST_BIN_URL && \
        sudo chmod +x $POLYBAR_FORECAST_PATH" &>/dev/null &
    loading_animation
    clean_line
    printf "Polybar forecast installed!\n"
fi

### TODO
#
### Chromium
### -> Extensions: Vimium, browser-playerctl, foxy-proxy, dark-reader,
###    JSONViewer, Mod header, React
#
### Dont forget to add the docker group
#
### Fix parallel execution of nvm

## NVM ###
if [ ! -d $NVM_DIR ]; then
    printf "\nInstalling NVM (Node version manager)";
    git clone "$NVM_URL" "$NVM_DIR" &> /dev/null &
    loading_animation
    clean_line
    cd "$NVM_DIR" && \
    git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" \
    $(git rev-list --tags --max-count=1)` &>/dev/null && \
    cd -;
    printf "NVM installed!\n"
fi

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

if nvm --version &> /dev/null && ! nvm run node --version &> /dev/null; then
    echo -n "Installing latest node with NVM";
    {
        nvm install node;
        nvm use node;
    } &>/dev/null &
    loading_animation;
    clean_line
    printf "Node Installed!\n"
fi

### Yarn ###
if npm --version &> /dev/null && ! yarn --version &> /dev/null; then
    echo -n "Installing yarn";
    npm install --global yarn &> /dev/null &
    loading_animation;
    clean_line
    printf "Yarn installed!\n";
fi

wait;

### Dotfiles ###
printf "\nWhere the dotfiles will live? (default: $(tilde_path $DOTFILES_DEFAULT_PATH)) "
read DOTFILES_PATH
echo -ne "\033[1A\r" # line up
clean_line
DOTFILES_PATH=${DOTFILES_PATH:-$DOTFILES_DEFAULT_PATH}
if [ ! -d $DOTFILES_PATH ]; then
    printf "Cloning dotfiles into $(tilde_path $DOTFILES_PATH)";
    git clone --quiet $DOTFILES_URL $DOTFILES_PATH &>/dev/null &
    loading_animation
    clean_line
    printf "Dotfiles cloned into $(tilde_path $DOTFILES_PATH\n)"
fi

### Symlinks ###
printf "Updating dotfiles symlinks to $(tilde_path $DOTFILES_PATH)\n\n"
ROOT_FILE_NAMES=($(ls -a $DOTFILES_PATH | grep -E "^\." | \
    grep -Ev "[\.]+$|\.git$" | xargs -n1 printf "%s "));
BACKUP_DIR_TILDE=$(tilde_path $BACKUP_DIR)
for ROOT_FILENAME in ${ROOT_FILE_NAMES[@]}; do
    TARGET_PATH="$DOTFILES_PATH/$ROOT_FILENAME";
    FILENAMES=("$ROOT_FILENAME")
    if [ -d $TARGET_PATH ]; then
        FILENAMES=($(ls $TARGET_PATH | xargs -n1 printf "$ROOT_FILENAME/%s "));
    fi
    for FILENAME in ${FILENAMES[@]}; do
        SRC_PATH="$HOME/$FILENAME";
        SRC_PATH_TILDE=$(tilde_path $SRC_PATH);
        TARGET_PATH="$DOTFILES_PATH/$FILENAME"
        TARGET_PATH_TILDE=$(tilde_path $TARGET_PATH);
        if [ -s $SRC_PATH ] || [ -L $SRC_PATH ]; then
            LINK_PATH=$(readlink $SRC_PATH)
            if [ $LINK_PATH == $TARGET_PATH ]; then
                echo "[SAME]    $SRC_PATH_TILDE -> $TARGET_PATH_TILDE";
                print_row
                continue;
            else
                if [ -d "$HOME/$ROOT_FILENAME" ]; then
                    mkdir -p "$BACKUP_DIR/$ROOT_FILENAME";
                fi
                mv "$SRC_PATH" "$BACKUP_DIR/$FILENAME";
                printf "[BACKUP]  $SRC_PATH_TILDE -> $TARGET_PATH_TILDE\n"
                printf "          (moved to $BACKUP_DIR_TILDE/$FILENAME)\n";
            fi
            printf "[UPDATED] ";
        else
            printf "[NEW]    ";
        fi
        ln -s $TARGET_PATH $SRC_PATH;
        printf "$SRC_PATH_TILDE -> $TARGET_PATH_TILDE\n"
        print_row
    done
done

### Tmux
echo -n "Installing tmux plugins"
/usr/bin/sh -c "tmux new -d -s plugins \
$TPM_DIR/scripts/install_plugins.sh && \
tmux kill-session -t plugins" &
loading_animation
clean_line
printf "tmux plugins installed!\n"

### Neovim ###
if [ ! -d $NVIM_PLUGINS_PATH ]; then
    if nvim --version &>/dev/null; then
        echo -n "Installing neovim plugins"
        nvim +PlugInstall +qa &>/dev/null &
        loading_animation
        clean_line
        printf "Neovim plugins installed!\n"
    fi

    # I got some troubles with Coc loading python language server and pynvim
    # solved my problems:
    if ! pip show pynvim &>/dev/null; then
        echo -n "Installing pynvim"
        pip install --user --upgrade pynvim &>/dev/null &
        loading_animation
        clean_line
        printf "Pynvim installed!\n"
    fi
fi

wait;
printf "All Done!\n";

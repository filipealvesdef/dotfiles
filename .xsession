xrandr --output DP-4 --rate 144 --primary
xrandr --output DP-2 --mode 2560x1440 --right-of DP-4
xrandr --output HDMI-0 --mode 3840x2160 --rate 60 --right-of DP-2
picom -b --experimental-backends
feh --bg-center "$HOME/.dotfiles/wallpapers/greenfog.jpg"

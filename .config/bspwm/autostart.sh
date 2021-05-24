#! /bin/sh
/usr/lib/xfce-polkit/xfce-polkit &
/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh &
/usr/lib/geoclue-2.0/demos/agent &
$HOME/.screenlayout/real.sh &
$HOME/.config/i3/bg.sh &
$HOME/.config/polybar/launch.sh
numlockx &
xsetroot -cursor_name left_ptr &
dunst &
blueberry-tray &
aria2c --enable-rpc --rpc-allow-origin-all --rpc-listen-all=true -l $HOME/.aria2c.log --quiet --dir=$HOME/Downloads/ &
x11vnc -quiet -display :0 -forever -usepw -mdns -o ~/vnc.log -auth guess &
thunar --daemon &
nm-applet &
pasystray &
steam-native -silent %U &
discord --start-minimized &
telegram-desktop -startintray &

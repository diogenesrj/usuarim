#! /bin/sh
#
#      ╻ ╻╻┏┓╻╻╺┳╸┏━┓┏━╸          ╻ ╻┏━┓╻ ╻┏━┓┏━┓╻┏┳┓
#      ┏╋┛┃┃┗┫┃ ┃ ┣┳┛┃     ╺━╸    ┃ ┃┗━┓┃ ┃┣━┫┣┳┛┃┃┃┃
#      ╹ ╹╹╹ ╹╹ ╹ ╹┗╸┗━╸          ┗━┛┗━┛┗━┛╹ ╹╹┗╸╹╹ ╹

userresources=$HOME/.Xresources
sysresources=/etc/X11/xinit/Xresources

# merge in defaults and keymaps
if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

# Launch dbus 
if [ -d /etc/X11/xinit/xinitrc.d ] ; then

    for f in /etc/X11/xinit/xinitrc.d/?* ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

#x cursor
xsetroot -cursor_name left_ptr&

#typematic delay/ rate
xset r rate 200 20

#Change blank time to 1 hour
xset s 3600 3600

#no bell
xset b off

# set monitor to sleep
xset s 600 600

numlockx on &

# SSH tunnel
if [ -f ~/bin/autossh.sh ] ; then
  autossh.sh &
fi

# Lower the brightness to a minimum
xbacklight -set 1


_start_session() {
  session=${1:-bspwm}
  case $session in
      bspwm             ) exec bspwm;;
      dwm               ) exec dwm;;
      i3                ) exec i3;;
      herbstuf|herbstluftwm     ) exec herbstluftwm --locked;;
      spectr|spectrwm           ) exec spectrwm 2> /tmp/spectrwm.log;;
      # No known session, try to run it as command
      *) exec "$1";;
  esac
}
_start_session "$@"



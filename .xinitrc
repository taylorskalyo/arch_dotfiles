#!/bin/sh

userresources="${HOME}/.Xresources"
usermodmap="${HOME}/.Xmodmap"
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# Merge in defaults and keymaps

if [ -f $sysresources ]; then
  xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
  xmodmap $sysmodmap
fi

if [ -f "${userresources}" ]; then
  xrdb -merge "${userresources}"
fi

if [ -f "${usermodmap}" ]; then
  xmodmap "${usermodmap}"
fi

# Start programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Start urxvt daemon
urxvtd -q -o -f

# Auto mount usb drives
#udiskie &

# Adjust screen tint based on time of day
#redshift &

# Default to bspwm
session=${1:-bspwm}

case $session in
  bspwm) exec bspwm;;
  *    ) exec "$@";; # unhandled session, try executing it as a command
esac

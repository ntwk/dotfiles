#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

# Disable the system bell
xset b off &

# Change keyboard repeat rate
xset r rate 250 30 &

# exec ion
# exec jwm
# exec wmaker
# exec startkde
# exec icewm
# exec blackbox
# exec gnome-session
# exec startfluxbox
# exec startxfce4
# exec xfce4-session
exec openbox-session
# exec startlxde
# exec pekwm
# exec i3

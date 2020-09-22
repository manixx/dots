#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

if [ -f $sysresources ]; then
	xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
	xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
	xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
	xmodmap "$usermodmap"
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

xset r rate 220 40

$HOME/.bin/toggle-redshift
$HOME/.bin/toggle-xautolock

pgrep -x unclutter || unclutter --timeout 1 &
pgrep -x dunst     || dunst &
pgrep -x xbindkeys || xbindkeys

while true; do
	export now=$(cat /sys/class/power_supply/BAT0/energy_now)
	export full=$(cat /sys/class/power_supply/BAT0/energy_full)

	bat=$(echo | awk ' { printf "%0.2f%\n", (ENVIRON["now"] / ENVIRON["full"] * 100); } ')

	xsetroot -name "  ${bat} | $(date +"%a %d.%b %y %H:%M")"
	sleep 4 
done &

exec dwm

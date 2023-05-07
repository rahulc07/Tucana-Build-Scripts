#!/bin/bash
export CFLAGS=-"O2"
export CXXFLAGS="-O2"

TARS="iceauth-1.0.9.tar.xz
luit-1.1.1.tar.bz2
mkfontscale-1.2.2.tar.xz
sessreg-1.1.3.tar.xz
setxkbmap-1.3.3.tar.xz
smproxy-1.0.7.tar.xz
x11perf-1.6.1.tar.bz2
xauth-1.1.2.tar.xz
xbacklight-1.2.3.tar.bz2
xcmsdb-1.0.6.tar.xz
xcursorgen-1.0.8.tar.xz
xdpyinfo-1.3.3.tar.xz
xdriinfo-1.0.7.tar.xz
xev-1.2.5.tar.xz
xgamma-1.0.7.tar.xz
xhost-1.0.9.tar.xz
xinput-1.6.3.tar.bz2
xkbcomp-1.4.6.tar.xz
xkbevd-1.1.5.tar.xz
xkbutils-1.0.5.tar.xz
xkill-1.0.6.tar.xz
xlsatoms-1.1.4.tar.xz
xlsclients-1.1.5.tar.xz
xmessage-1.0.6.tar.xz
xmodmap-1.0.11.tar.xz
xpr-1.1.0.tar.xz
xprop-1.2.6.tar.xz
xrandr-1.5.2.tar.xz
xrdb-1.2.1.tar.bz2
xrefresh-1.0.7.tar.xz
xset-1.2.5.tar.xz
xsetroot-1.1.3.tar.xz
xvinfo-1.1.5.tar.xz
xwd-1.0.8.tar.bz2
xwininfo-1.1.5.tar.bz2
xwud-1.0.6.tar.xz
"
for TAR in $TARS; do
    APP=$(echo $TAR | sed 's/\.tar.*//' | sed 's|-[^-]*$||g')
    cp app_template $APP
    sed -i "s/TEMPLATE/$TAR/" $APP
done


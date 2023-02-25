#!/bin/bash
set -e
sed -i "s|doc/\$PACKAGE|doc/\$PACKAGE\ --libdir=/usr/lib32|" *
# Vars
export DATA='
export CFLAGS+="-m32"
export CXXFLAGS+="-m32"
export PKG_CONFIG="i686-pc-linux-gnu-pkg-config"'
export ESCAPED_DATA="$(echo "${DATA}" | sed ':a;N;$!ba;s/\n/\\n/g' | sed 's/\$/\\$/g')"
sed -i "s/#\ Get.*/$ESCAPED_DATA/g" *

# Make
INSTALL='
mkdir -p /pkgs/$PACKAGE/usr/lib32

mkdir -p /pkgs/$PACKAGE/usr/lib32
make DESTDIR=$PWD/DESTDIR install
cp -Rv DESTDIR/usr/lib32/* /pkgs/$PACKAGE/usr/lib32
rm -rf DESTDIR
cp -rpv /pkgs/$PACKAGE/* /
cp -Rv DESTDIR/usr/lib32/* /pkgs/$PACKAGE/usr/lib32
rm -rf DESTDIR
cp -rpv /pkgs/$PACKAGE/* /'
ESCAPED_INSTALL="$(echo "${INSTALL}" | sed ':a;N;$!ba;s|\n|\\n|g' | sed 's|\$|\\$|g')"
sed -i 's/sudo\ make\ install//' *
echo last sed
sed -i "s|.*make\ DEST.*|$ESCAPED_INSTALL|" *

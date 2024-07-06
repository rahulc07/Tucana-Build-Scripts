#!/bin/bash

export CFLAGS=-"O2"
export CXXFLAGS="-O2"


PKG_VER=29.4
URL=https://ftp.gnu.org/gnu/emacs/emacs-$PKG_VER.tar.xz
TAR=$(echo $URL | sed -r 's|(.*)/||')
DIR=$(echo $TAR | sed 's|.tar.*||g')
PACKAGE=$(echo $DIR | sed 's|-[^-]*$||g')

# Get Package

cd /blfs/builds
wget $URL
tar -xvf $TAR
cd $DIR

# Build

./configure --prefix=/usr


make -j16


# Install
sudo make DESTDIR=/pkgs/$PACKAGE install
sudo make install
cd /pkgs


sudo echo "gtk-update-icon-cache -qtf /usr/share/icons/hicolor" > /pkgs/$PACKAGE/postinst
sudo echo "harfbuzz giflib gnutls jansson libtiff imagemagick" > /pkgs/$PACKAGE/depends
sudo tar -czvpf $PACKAGE.tar.xz $PACKAGE
sudo cp $PACKAGE.tar.xz /finished


cd /blfs/builds
sudo rm -r $DIR



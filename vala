#!/bin/bash

export CFLAGS=-"O2"
export CXXFLAGS="-O2"



PKG_VER=0.56.17
MAJOR=$(echo $PKG_VER | sed 's|.[^.]*$||g')
URL=https://download.gnome.org/sources/vala/$MAJOR/vala-$PKG_VER.tar.xz
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


make -j22


# Install
sudo make DESTDIR=/pkgs/$PACKAGE install
sudo make install
cd /pkgs



sudo echo "glib"  > /pkgs/$PACKAGE/depends
sudo echo "graphviz" > /pkgs/$PACKAGE/make-depends
sudo tar -cvzpf $PACKAGE.tar.xz $PACKAGE
sudo cp $PACKAGE.tar.xz /finished


cd /blfs/builds
sudo rm -r $DIR



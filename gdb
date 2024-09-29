#!/bin/bash

export CFLAGS=-"O2"
export CXXFLAGS="-O2"


PKG_VER=15.2
URL=https://ftp.gnu.org/gnu/gdb/gdb-$PKG_VER.tar.xz
TAR=$(echo $URL | sed -r 's|(.*)/||')
DIR=$(echo $TAR | sed 's|.tar.*||g')
PACKAGE=$(echo $DIR | sed 's|-[^-]*$||g')

# Get Package

cd /blfs/builds
wget $URL
tar -xvf $TAR
cd $DIR

# Build
export CFLAGS="-O2 -g1"
sed '/return/s/rl.*characters/(char *) &/' -i gdb/completer.c
mkdir build &&
cd    build &&

../configure --prefix=/usr          \
             --with-system-readline \
             --with-python=/usr/bin/python3


make -j16


# Install
sudo make DESTDIR=/pkgs/$PACKAGE install
strip /pkgs/$PACKAGE/usr/bin/gdb
strip /pkgs/$PACKAGE/usr/bin/gdbserver
cd /pkgs



sudo echo "" > /pkgs/$PACKAGE/depends
sudo echo "" > /pkgs/$PACKAGE/make-depends
sudo tar -cvzpf $PACKAGE.tar.xz $PACKAGE
sudo cp $PACKAGE.tar.xz /finished


cd /blfs/builds
sudo rm -r $DIR



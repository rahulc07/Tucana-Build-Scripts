#!/bin/bash

export CFLAGS=-"O2"
export CXXFLAGS="-O2"

URL=https://www.nasm.us/pub/nasm/releasebuilds/2.16.01/nasm-2.16.01.tar.xz
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



sudo echo "" > /pkgs/$PACKAGE/depends
sudo echo "" > /pkgs/$PACKAGE/make-depends
sudo tar -cvzpf $PACKAGE.tar.xz $PACKAGE
sudo cp $PACKAGE.tar.xz /finished


cd /blfs/builds
sudo rm -r $DIR



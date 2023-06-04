#!/bin/bash

export CFLAGS=-"O2"
export CXXFLAGS="-O2"
PKG_VER=2.3.3
URL=https://www.jedsoft.org/releases/slang/slang-$PKG_VER.tar.bz2
TAR=$(echo $URL | sed -r 's|(.*)/||')
DIR=$(echo $TAR | sed 's|.tar.*||g')
PACKAGE=$(echo $DIR | sed 's|-[^-]*$||g')

# Get Package

cd /blfs/builds
wget $URL
tar -xvf $TAR
cd $DIR

# Build

./configure --prefix=/usr \
            --sysconfdir=/etc \
            --with-readline=gnu


make -j16


# Install
sudo make DESTDIR=/pkgs/$PACKAGE install
sudo make install
cd /pkgs



sudo echo "libpng pcre" > /pkgs/$PACKAGE/depends
sudo echo "" > /pkgs/$PACKAGE/make-depends
sudo tar -cvzpf $PACKAGE.tar.xz $PACKAGE
sudo cp $PACKAGE.tar.xz /finished


cd /blfs/builds
sudo rm -r $DIR



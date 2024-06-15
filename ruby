#!/bin/bash

export CFLAGS=-"O2"
export CXXFLAGS="-O2"


PKG_VER=3.3.3
MAJOR=$(echo $PKG_VER | sed 's|.[^.]*$||g')
URL=https://cache.ruby-lang.org/pub/ruby/$MAJOR/ruby-$PKG_VER.tar.xz
TAR=$(echo $URL | sed -r 's|(.*)/||')
DIR=$(echo $TAR | sed 's|.tar.*||g')
PACKAGE=$(echo $DIR | sed 's|-[^-]*$||g')

# Get Package

cd /blfs/builds
wget $URL
tar -xvf $TAR
cd $DIR

# Build

./configure --prefix=/usr      \
            --enable-shared    \
            --without-valgrind \
            --without-baseruby \
            --docdir=/usr/share/doc/ruby


make -j22


# Install
sudo make DESTDIR=/pkgs/$PACKAGE install
sudo make install
cd /pkgs



sudo echo "libyaml graphviz" > /pkgs/$PACKAGE/depends
sudo echo "rustc" > /pkgs/$PACKAGE/make-depends
sudo tar -cvzpf $PACKAGE.tar.xz $PACKAGE
sudo cp $PACKAGE.tar.xz /finished


cd /blfs/builds
sudo rm -r $DIR



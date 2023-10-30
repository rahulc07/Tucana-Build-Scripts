#!/bin/bash
#NLFS
export CFLAGS=-"O2"
export CXXFLAGS="-O2"


PKG_VER=1.7
URL=https://github.com/stedolan/jq/releases/download/jq-$PKG_VER/jq-$PKG_VER.tar.gz
TAR=$(echo $URL | sed -r 's|(.*)/||')
DIR=$(echo $TAR | sed 's|.tar.*||g')
PACKAGE=$(echo $DIR | sed 's|-[^-]*$||g')

# Get Package

cd /blfs/builds
wget $URL
tar -xvf $TAR
cd $DIR

# Build
export CFLAGS+=" -fPIE"
autoreconf -fiv 
./configure --prefix=/usr --disable-mantainer-mode


make -j16


# Install
sudo make DESTDIR=/pkgs/$PACKAGE install
sudo make install
cd /pkgs



sudo echo "jsoncpp" > /pkgs/$PACKAGE/depends
sudo echo "" > /pkgs/$PACKAGE/make-depends
sudo tar -cvzpf $PACKAGE.tar.xz $PACKAGE
sudo cp $PACKAGE.tar.xz /finished


cd /blfs/builds
sudo rm -r $DIR



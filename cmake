#!/bin/bash

export CFLAGS=-"O2"
export CXXFLAGS="-O2"


PKG_VER=3.30.2
MAJOR=$(echo $PKG_VER | sed 's|.[^.]*$||g')
URL=https://cmake.org/files/v$MAJOR/cmake-$PKG_VER.tar.gz
TAR=$(echo $URL | sed -r 's|(.*)/||')
DIR=$(echo $TAR | sed 's|.tar.*||g')
PACKAGE=$(echo $DIR | sed 's|-[^-]*$||g')

# Get Package

cd /blfs/builds
wget $URL
tar -xvf $TAR
cd $DIR

# Build

sed -i '/"lib64"/s/64//' Modules/GNUInstallDirs.cmake
./bootstrap --prefix=/usr        \
            --system-libs        \
            --mandir=/share/man  \
            --no-system-jsoncpp  \
            --no-system-librhash \
            --no-system-cppdap   \
            --docdir=/share/doc/cmake-$PKG_VER



make -j20


# Install
sudo make DESTDIR=/pkgs/$PACKAGE install
sudo make install
cd /pkgs



sudo echo "libuv curl libarchive nghttp2" > /pkgs/$PACKAGE/depends
sudo tar -cvzpf $PACKAGE.tar.xz $PACKAGE
sudo cp $PACKAGE.tar.xz /finished


cd /blfs/builds
sudo rm -r $DIR



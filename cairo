#!/bin/bash

export CFLAGS=-"O2"
export CXXFLAGS="-O2"

URL=https://download.gnome.org/sources/cairo/1.17/cairo-1.17.6.tar.xz
TAR=$(echo $URL | sed -r 's|(.*)/||')
DIR=$(echo $TAR | sed 's|.tar.*||g')
PACKAGE=$(echo $DIR | sed 's|-[^-]*$||g')

# Get Package

cd /blfs/builds
wget $URL
tar -xvf $TAR
cd $DIR

# Build

sed 's/PTR/void */' -i util/cairo-trace/lookup-symbol.c
sed -e "/@prefix@/a exec_prefix=@exec_prefix@" \
    -i util/cairo-script/cairo-script-interpreter.pc.in
./configure --prefix=/usr    \
            --disable-static \
            --enable-tee \
	    --enable-gl \


make -j16


# Install
sudo make DESTDIR=/pkgs/$PACKAGE install
sudo make install
cd /pkgs



sudo echo "pixman libpng fontconfig glib xorg-libs" > /pkgs/$PACKAGE/depends
sudo echo "" > /pkgs/$PACKAGE/make-depends
sudo tar -cvzpf $PACKAGE.tar.xz $PACKAGE
sudo cp $PACKAGE.tar.xz /finished


cd /blfs/builds
sudo rm -r $DIR



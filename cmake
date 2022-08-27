#!/bin/bash
URL=https://cmake.org/files/v3.24/cmake-3.24.1.tar.gz
TAR=$(echo $URL | sed -r 's|(.*)/||')
DIR=$(echo $TAR | sed 's|.tar.*||g')
PACKAGE=$(echo $DIR | sed 's|-[^-]*$||g')

# Get Package

cd /blfs/builds
wget $URL
wget https://www.linuxfromscratch.org/patches/blfs/svn/cmake-3.24.1-upstream_fix-1.patch
tar -xvf $TAR
cd $DIR

# Build

patch -Np1 -i ../cmake-3.24.1-upstream_fix-1.patch
sed -i '/"lib64"/s/64//' Modules/GNUInstallDirs.cmake
./bootstrap --prefix=/usr        \
            --system-libs        \
            --mandir=/share/man  \
            --no-system-jsoncpp  \
            --no-system-librhash \
            --docdir=/share/doc/cmake-3.24.1 



make -j16


# Install
sudo make DESTDIR=/pkgs/$PACKAGE install
sudo make install
cd /pkgs



sudo echo "libuv curl libarchive nghttp2" > /pkgs/$PACKAGE/depends
sudo tar -cvzpf $PACKAGE.tar.xz $PACKAGE
sudo cp $PACKAGE.tar.xz /finished


cd /blfs/builds
sudo rm -r $DIR



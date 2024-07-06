#!/bin/bash

export CFLAGS=-"O2"
export CXXFLAGS="-O2"
PKG_VER=5.4.7
URL=https://www.lua.org/ftp/lua-$PKG_VER.tar.gz
TAR=$(echo $URL | sed -r 's|(.*)/||')
DIR=$(echo $TAR | sed 's|.tar.*||g')
PACKAGE=$(echo $DIR | sed 's|-[^-]*$||g')

# Get Package

cd /blfs/builds
wget $URL
wget  https://www.linuxfromscratch.org/patches/blfs/svn/lua-$PKG_VER-shared_library-1.patch
tar -xvf $TAR
cd $DIR

# Build

cat > lua.pc << "EOF"
V=5.4
R=5.4.6

prefix=/usr
INSTALL_BIN=${prefix}/bin
INSTALL_INC=${prefix}/include
INSTALL_LIB=${prefix}/lib
INSTALL_MAN=${prefix}/share/man/man1
INSTALL_LMOD=${prefix}/share/lua/${V}
INSTALL_CMOD=${prefix}/lib/lua/${V}
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include

Name: Lua
Description: An Extensible Extension Language
Version: ${R}
Requires:
Libs: -L${libdir} -llua -lm -ldl
Cflags: -I${includedir}
EOF
patch -Np1 -i ../lua-5.4.6-shared_library-1.patch &&
make linux -j20




# Install
make INSTALL_TOP=/pkgs/$PACKAGE/usr                \
     INSTALL_DATA="cp -d"            \
     INSTALL_MAN=/usr/share/man/man1 \
     TO_LIB="liblua.so liblua.so.5.4 liblua.so.5.4.6" \
     install
install -v -m644 -D lua.pc /pkgs/$PACKAGE/usr/lib/pkgconfig/lua.pc
cd /pkgs



sudo echo "" > /pkgs/$PACKAGE/depends
sudo echo "" > /pkgs/$PACKAGE/make-depends
sudo tar -cvzpf $PACKAGE.tar.xz $PACKAGE
sudo cp $PACKAGE.tar.xz /finished
cp -rpv /pkgs/$PACKAGE/* /

cd /blfs/builds
sudo rm -r $DIR



#!/bin/bash

export CFLAGS=-"O2"
export CXXFLAGS="-O2"
#ARCH_PKG=go
#ARCH_VAR=pkgver
PKG_VER=1.20.5
URL=https://go.dev/dl/go$PKG_VER.src.tar.gz
TAR=$(echo $URL | sed -r 's|(.*)/||')
DIR=go
PACKAGE=go

# Get Package

cd /blfs/builds
wget $URL
tar -xvf $TAR
cd $DIR

# Build

export GOARCH=amd64
export GOAMD64=v1 # make sure we're building for the right x86-64 version
export GOROOT_FINAL=/usr/lib/go
export GOROOT_BOOTSTRAP=/opt/usr/lib/go
cd src
./make.bash -v 



# Install
mkdir -p /pkgs/$PACKAGE/usr/bin
mkdir -p /pkgs/$PACKAGE/usr/lib/go
mkdir -p /pkgs/$PACKAGE/usr/share/doc/go
cd ../
cp -rpv bin pkg src lib misc api test /pkgs/$PACKAGE/usr/lib/go

cp -rpv doc/* /pkgs/$PACKAGE/usr/share/doc/go

ln -sfv /usr/lib/go/bin/go /pkgs/$PACKAGE/usr/bin/go
ln -sfv /usr/lib/go/bin/gofmt /pkgs/$PACKAGE/usr/bin/gofmt

cd /pkgs



sudo echo "glibc" > /pkgs/$PACKAGE/depends
sudo echo "" > /pkgs/$PACKAGE/make-depends
sudo tar -cvzpf $PACKAGE.tar.xz $PACKAGE
sudo cp $PACKAGE.tar.xz /finished


cd /blfs/builds
sudo rm -r $DIR



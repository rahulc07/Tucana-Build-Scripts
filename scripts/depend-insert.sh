#!/bin/bash
export CFLAGS=-"O2"
export CXXFLAGS="-O2"

sed -i "s|echo\ \"\"\ > /pkgs/.*/depends|echo\ \"$2\" > /pkgs/\$PACKAGE/depends|"  $1

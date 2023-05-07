#!/bin/bash
export CFLAGS=-"O2"
export CXXFLAGS="-O2"

cp $1 bak/$1.bak
sed -i 's#/pkgs/gnome42#/pkgs#g' $1
sed -i 's#/blfs/day18/gnome#/blfs/builds#g' $1
sed -i 's#./dir.sh##g' $1
sed -i 's#sudo\ porg\ -lp\ $PACKAGE\ "##g' $1
sed -i 's#install"#install#g' $1
sed -i 's#ninja\ install#ninja\ install\ \&\&\ DESTDIR=/pkgs/$PACKAGE\ ninja\ install#g' $1
sed -i 's/cvpf/cvzpf/g' $1
sed -i 's#/finished/gnome42#/finished#g' $1
sed -i 's#/gnome#/pkgs#g' $1
cat $1 | grep gnome

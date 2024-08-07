#!/bin/bash
for i in $(find -maxdepth 1 -type f | sed 's!.*/!!' | sed 's/lib32-//g'); do 
   echo $i:
   if [[ -f ../$i ]] && ! cat lib32-$i | grep -q 'PKG_VER'; then
        URLLINE=$(cat ../$i | grep 'URL=')
	echo $URLLINE
	cat ../$i | grep 'MAJOR=' > /dev/null
	if [[ $? == 0 ]]; then
           MAJORLINE=$(cat ../$i | grep 'MAJOR=')
	   echo $MAJORLINE
	fi
	PKGVERLINE=$(cat ../$i | grep 'PKG_VER=')
	echo $PKGVERLINE
   elif [[ -f ../base/$i ]] && ! cat lib32-$i | grep -q 'PKG_VER'; then
        URLLINE=$(cat ../base/$i | grep 'URL=')
	echo $URLLINE
	cat ../base/$i | grep 'MAJOR=' > /dev/null
	if [[ $? == 0 ]]; then
           MAJORLINE=$(cat ../base/$i | grep 'MAJOR=')
	   echo $MAJORLINE
	fi
	PKGVERLINE=$(cat ../base/$i | grep 'PKG_VER=')
	echo $PKGVERLINE
   fi
   echo ""
   
done

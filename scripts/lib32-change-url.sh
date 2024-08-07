#!/bin/bash
for i in $(find -maxdepth 1 -type f | sed 's!.*/!!' | sed 's/lib32-//g'); do 
   echo $i:
   if [[ -f ../$i ]]; then
        URLLINE=$(cat ../$i | grep 'URL=')
	echo $URLLINE
	MAJORLINE=" "
	cat ../$i | grep 'MAJOR=' > /dev/null
	if [[ $? == 0 ]]; then
           MAJORLINE=$(cat ../$i | grep 'MAJOR=')
	   echo $MAJORLINE
	fi
	PKGVERLINE=$(cat ../$i | grep 'PKG_VER=')
	if cat lib32-$i | grep -v 'PKG_VER='; then
	    sed -i 's/PKG_VER=.*//'lib32-$i
	fi
	echo $PKGVERLINE
	sed -i "s~URL=.*~${PKGVERLINE}\n${MAJORLINE}\n${URLLINE}~" lib32-$i
   elif [[ -f ../base/$i ]]; then
        URLLINE=$(cat ../base/$i | grep 'URL=')
	echo $URLLINE
	MAJORLINE=" "
	cat ../base/$i | grep -E 'MAJOR=|MINOR=' > /dev/null
	if [[ $? == 0 ]]; then
           MAJORLINE=$(cat ../base/$i | grep 'MINOR=|MAJOR=')
	   echo $MAJORLINE
	fi
	PKGVERLINE=$(cat ../base/$i | grep 'PKG_VER=')
	if cat lib32-$i | grep -v 'PKG_VER='; then
	    sed -i 's/PKG_VER=.*//' lib32-$i
	fi
	echo $PKGVERLINE
	sed -i "s~URL=.*~${PKGVERLINE}\n${MAJORLINE}\n${URLLINE}~" lib32-$i
   fi
   echo ""
   
done

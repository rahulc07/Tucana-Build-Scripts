#!/bin/bash
for i in $(find -maxdepth 1 -type f | sed 's!.*/!!' | sed 's/lib32-//g'); do 
   if [[ -f ../$i ]]; then
        LINES=$(cat ../$i | grep '\S' | head -n6)
        cat lib32-$i | tail -n +6
 
   elif [[ -f ../base/$i ]]; then
        LINES=$(cat ../base/$i | grep '\S' | head -n8)
        cat lib32-$i | tail -n +8
   fi
   
done

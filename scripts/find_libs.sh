#!/bin/bash
for file in $(ls /usr/lib)
do
	if ldd /usr/lib/$file | grep $1; then
		echo "$file" >> /home/rahul/file
	fi
done

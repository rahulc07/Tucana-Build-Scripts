#!/bin/bash

export CFLAGS=-"O2"
export CXXFLAGS="-O2"

for file in $(ls /usr/lib)
do
	if ldd /usr/lib/$file | grep $1; then
		echo "$file" >> /home/rahul/file1
	fi
done

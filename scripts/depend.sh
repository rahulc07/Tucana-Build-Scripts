#!/bin/bash
export CFLAGS=-"O2"
export CXXFLAGS="-O2"

string=$(echo $1 | sed "s/\,//g" | sed 's/and//g' | tr '[:upper:]' '[:lower:]')
echo $string


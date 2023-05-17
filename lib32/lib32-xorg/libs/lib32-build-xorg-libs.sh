#!/bin/bash

export CFLAGS=-"O2"
export CXXFLAGS="-O2"

# Do the build in the right order
bash lib32-xtrans
bash lib32-libX11
bash lib32-libXext
bash lib32-libFS
bash lib32-libICE
bash lib32-libSM
bash lib32-libXScrnSaver
bash lib32-libXt
bash lib32-libXmu
bash lib32-libXpm
bash lib32-libXaw
bash lib32-libXfixes
bash lib32-libXcomposite
bash lib32-libXrender
bash lib32-libXcursor
bash lib32-libXdamage
bash lib32-libfontenc
bash lib32-libXfont2
bash lib32-libXft
bash lib32-libXi
bash lib32-libXinerama
bash lib32-libXrandr
bash lib32-libXres
bash lib32-libXtst
bash lib32-libXv
bash lib32-libXvMC
bash lib32-libXxf86dga
bash lib32-libXxf86vm
bash lib32-libdmx
bash lib32-libpciaccess
bash lib32-libxkbfile
bash lib32-libxshmfence
bash lib32-xorg-libs

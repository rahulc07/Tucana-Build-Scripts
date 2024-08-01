#!/bin/bash
set -e
# Building Depends
bash ecm
bash libdbusmenu-qt
bash polkit-qt
bash polkit-qt5
bash phonon
#bash phonon-backend-vlc
bash plasma-wayland-protocols
sudo bash qcoro
sudo bash qca
# Plasma5-limited
cd plasma5-limited
bash -e build_plasma5_limited.sh
cd ..
# KF6
cd kf6
bash -e build_kf6.sh
cd ..
sudo bash kirigami-addons
sudo bash pulseaudio-qt
# Desktop
cd plasma
bash -e build_plasma.sh
cd ..
# Apps
sudo bash poppler
cd plasma-apps
bash -e build_plasma_apps.sh

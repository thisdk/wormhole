#!/bin/bash

hostnamectl set-hostname archlinux

modprobe tcp_bbr

echo "tcp_bbr" > /etc/modules-load.d/80-bbr.conf

echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.d/80-bbr.conf

echo "net.core.default_qdisc=fq" >> /etc/sysctl.d/80-bbr.conf

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.d/30-ipforward.conf

cho "set mouse-=a" > ~/.vimrc

mkdir /etc/sing-box

mkdir /etc/docker

wget https://raw.githubusercontent.com/thisdk/wormhole/main/daemon.json -O /etc/docker/daemon.json

pacman -Syyu --noconfirm

pacman -S --noconfirm base-devel docker wget vim

systemctl enable --now docker

vim /etc/netctl/eth0

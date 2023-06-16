#!/bin/bash

hostnamectl set-hostname archlinux

modprobe tcp_bbr

echo "tcp_bbr" > /etc/modules-load.d/80-bbr.conf

echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.d/80-bbr.conf

echo "net.core.default_qdisc=fq" >> /etc/sysctl.d/80-bbr.conf

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.d/30-ipforward.conf

echo "net.ipv6.conf.default.forwarding=1" >> /etc/sysctl.d/30-ipforward.conf

echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.d/30-ipforward.conf

mkdir /etc/docker

wget https://raw.githubusercontent.com/thisdk/wormhole/main/daemon.json -O /etc/docker/daemon.json

mkdir /etc/sing-box

pacman -Syyu --noconfirm

pacman -S --noconfirm base-devel docker

systemctl enable --now docker

vim /etc/sing-box/config.json

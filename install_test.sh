#!/bin/bash

hostnamectl set-hostname archlinux

modprobe tcp_bbr

echo "tcp_bbr" > /etc/modules-load.d/80-bbr.conf

echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.d/80-bbr.conf

echo "net.core.default_qdisc=fq" >> /etc/sysctl.d/80-bbr.conf

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.d/30-ipforward.conf

mkdir /etc/sing-box

pacman -S --noconfirm docker

systemctl enable --now docker

mkdir temp && cd temp && mkdir game

wget https://raw.githubusercontent.com/thisdk/wormhole/main/kcptun

wget https://raw.githubusercontent.com/thisdk/wormhole/main/speederv2

wget https://raw.githubusercontent.com/thisdk/wormhole/main/udp2raw

docker build -f kcptun -t kcptun ./game/

docker build -f speederv2 -t speederv2 ./game/

docker build -f udp2raw -t udp2raw ./game/

cd .. && rm -rf temp

docker run --restart=always --network host --name speederv2 -d speederv2 -c -l127.0.0.1:51820 -r127.0.0.1:8400 -k jason -f2:8 --timeout 0

docker run --restart=always --network host --name udp2raw_wg --cap-add NET_ADMIN -d udp2raw -c -l127.0.0.1:8400 -r96.43.92.126:8484 -k jason --raw-mode faketcp --cipher-mode none --auth-mode none --keep-rule -a

docker run --restart=always --network host --name kcptun -d kcptun -l 127.0.0.1:8388 -r 127.0.0.1:8500 -mode fast3 -nocomp -mtu 1350 -crypt none -sndwnd 2048 -rcvwnd 2048 -datashard 2 -parityshard 2 -dscp 46

docker run --restart=always --network host --name udp2raw_ss --cap-add NET_ADMIN -d udp2raw -c -l127.0.0.1:8500 -r96.43.92.126:8585 -k jason --raw-mode faketcp --cipher-mode none --auth-mode none --keep-rule -a

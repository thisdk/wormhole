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

mkdir temp && cd temp && mkdir game

wget https://raw.githubusercontent.com/thisdk/wormhole/main/kcptun

wget https://raw.githubusercontent.com/thisdk/wormhole/main/udp2raw

docker build -f kcptun -t kcptun ./game/

docker build -f udp2raw -t udp2raw ./game/

cd .. && rm -rf temp

docker run --restart=always --network bridge --name watchtower -v /var/run/docker.sock:/var/run/docker.sock -d containrrr/watchtower:latest --cleanup

docker run --restart=always --network host --name sing-box -v /etc/sing-box:/etc/sing-box -d gzxhwq/sing-box:latest

docker run --restart=always --network host --name udp2raw_ipv4 --cap-add NET_ADMIN -d udp2raw -s -l0.0.0.0:8585 -r127.0.0.1:8400 -k jason --raw-mode faketcp --cipher-mode aes128cbc --auth-mode md5 -a

docker run --restart=always --network host --name udp2raw_ipv6 --cap-add NET_ADMIN -d udp2raw -s -l[::]:8484 -r127.0.0.1:8400 -k jason --raw-mode faketcp --cipher-mode aes128cbc --auth-mode md5 -a

docker run --restart=always --network host --name kcptun -d kcptun -l 127.0.0.1:8400 -t 127.0.0.1:8388 -mode fast3 -nocomp -mtu 1350 -crypt none -sndwnd 2048 -rcvwnd 2048 -datashard 2 -parityshard 2 -dscp 46

vim /etc/sing-box/config.json

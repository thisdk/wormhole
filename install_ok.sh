#!/bin/bash

mkdir temp && cd temp && mkdir game

wget https://raw.githubusercontent.com/thisdk/wormhole/main/kcptun

wget https://raw.githubusercontent.com/thisdk/wormhole/main/udp2raw

docker build -f kcptun -t kcptun ./game/

docker build -f udp2raw -t udp2raw ./game/

cd .. && rm -rf temp

docker run --restart=always --network bridge --name freenom -v /etc/freenom:/conf -v /etc/freenom/logs:/app/logs -d luolongfei/freenom

docker run --restart=always --network bridge --name watchtower -v /var/run/docker.sock:/var/run/docker.sock -d containrrr/watchtower --cleanup

docker run --restart=always --network host --name sing-box -v /etc/sing-box:/etc/sing-box -d ghcr.io/sagernet/sing-box run -c /etc/sing-box/config.json

docker run --restart=always --network host --name udp2raw_ipv4 --cap-add NET_ADMIN -d udp2raw -s -l0.0.0.0:8584 -r127.0.0.1:8400 -k jason --raw-mode faketcp --cipher-mode aes128cbc --auth-mode md5 -a

docker run --restart=always --network host --name udp2raw_ipv6 --cap-add NET_ADMIN -d udp2raw -s -l[::]:8586 -r127.0.0.1:8400 -k jason --raw-mode faketcp --cipher-mode aes128cbc --auth-mode md5 -a

docker run --restart=always --network host --name kcptun -d kcptun -l 127.0.0.1:8400 -t 127.0.0.1:8388 -mode fast3 -nocomp -mtu 1350 -crypt none -sndwnd 2048 -rcvwnd 2048 -datashard 2 -parityshard 2 -dscp 46

#!/bin/bash

mkdir temp && cd temp && mkdir game

wget https://raw.githubusercontent.com/thisdk/wormhole/main/kcptun

wget https://raw.githubusercontent.com/thisdk/wormhole/main/speederv2

wget https://raw.githubusercontent.com/thisdk/wormhole/main/udp2raw

docker build -f kcptun -t kcptun ./game/

docker build -f speederv2 -t speederv2 ./game/

docker build -f udp2raw -t udp2raw ./game/

cd .. && rm -rf temp

docker run --restart=always --network bridge --name freenom -v /etc/freenom:/conf -v /etc/freenom/logs:/app/logs -d luolongfei/freenom

docker run --restart=always --network bridge --name watchtower -v /var/run/docker.sock:/var/run/docker.sock -d containrrr/watchtower --cleanup

docker run --restart=always --network host --name sing-box -v /etc/sing-box:/etc/sing-box -d ghcr.io/sagernet/sing-box run -c /etc/sing-box/config.json

docker run --restart=always --network host --name udp2raw --cap-add NET_ADMIN -d udp2raw -s -l0.0.0.0:8585 -r127.0.0.1:8500 -k jason --raw-mode faketcp --cipher-mode xor --auth-mode simple -a

docker run --restart=always --network host --name speederv2 -d speederv2 -s -l127.0.0.1:8500 -r127.0.0.1:8400 -k jason -f2:4 --timeout 0

docker run --restart=always --network host --name kcptun -d kcptun -l 127.0.0.1:8400 -t 127.0.0.1:8388 -mode fast3 -nocomp -mtu 768 -crypt none -sndwnd 2048 -rcvwnd 2048 -datashard 0 -parityshard 0 -dscp 46

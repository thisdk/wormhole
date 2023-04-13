#!/bin/bash

mkdir temp && cd temp && mkdir empty

wget https://raw.githubusercontent.com/thisdk/wormhole/main/kcptun

wget https://raw.githubusercontent.com/thisdk/wormhole/main/speederv2

wget https://raw.githubusercontent.com/thisdk/wormhole/main/udp2raw

docker build -f kcptun -t kcptun ./empty/

docker build -f speederv2 -t speederv2 ./empty/

docker build -f udp2raw -t udp2raw ./empty/

docker run --restart=always --network host --name kcptun -d kcptun -l 127.0.0.1:29900 -t 127.0.0.1:1080 -mode fast3 -nocomp -mtu 1350 -crypt none -sndwnd 2048 -rcvwnd 2048 -datashard 2 -parityshard 2 -dscp 46

docker run --restart=always --network host --name speederv2 -d speederv2 -s -l127.0.0.1:8388 -r127.0.0.1:1080 -k jason -f2:4 --timeout 0

docker run --restart=always --network host --name udp2raw_kcp --cap-add NET_ADMIN -d udp2raw -s -l0.0.0.0:8585 -r127.0.0.1:8388 -k jason --raw-mode faketcp --cipher-mode none --auth-mode none --keep-rule -a

docker run --restart=always --network host --name udp2raw_udp --cap-add NET_ADMIN -d udp2raw -s -l0.0.0.0:8686 -r127.0.0.1:8388 -k jason --raw-mode faketcp --cipher-mode none --auth-mode none --keep-rule -a

cd .. && rm -rf temp

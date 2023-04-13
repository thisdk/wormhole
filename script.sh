#!/bin/bash

mkdir temp && cd temp

wget https://raw.githubusercontent.com/thisdk/wormhole/main/kcptun

wget https://raw.githubusercontent.com/thisdk/wormhole/main/speederv2

wget https://raw.githubusercontent.com/thisdk/wormhole/main/udp2raw_udp

wget https://raw.githubusercontent.com/thisdk/wormhole/main/udp2raw_kcp

docker build -f kcptun -t kcptun .

docker build -f speederv2 -t speederv2 .

docker build -f udp2raw_kcp -t udp2raw_kcp .

docker build -f udp2raw_udp -t udp2raw_udp .

docker run --restart=always --network host --name kcptun -d kcptun

docker run --restart=always --network host --name speederv2 -d speederv2

docker run --restart=always --network host --name udp2raw_udp --cap-add NET_ADMIN -d udp2raw_udp

docker run --restart=always --network host --name udp2raw_kcp --cap-add NET_ADMIN -d udp2raw_kcp

cd .. && rm -rf temp

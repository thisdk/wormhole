# wormhole

docker run --restart=always --network host --name kcptun -d kcptun
docker run --restart=always --network host --name speederv2 -d speederv2
docker run --restart=always --network host --name udp2raw --cap-add NET_ADMIN -d udp2raw

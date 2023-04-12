# wormhole

docker build -f kcptun -t kcptun .

docker build -f speederv2 -t speederv2 .

docker build -f udp2raw -t udp2raw .

docker run --restart=always --network host --name kcptun -d kcptun

docker run --restart=always --network host --name speederv2 -d speederv2

docker run --restart=always --network host --name udp2raw --cap-add NET_ADMIN -d udp2raw

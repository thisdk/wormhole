FROM alpine:latest

ARG UDP2RAW_VERSION="20230206.0"
ARG UDPSPEEDER_VERSION="20230206.0"

ARG UDP2RAW_URL="https://github.com/wangyu-/udp2raw/releases/download/${UDP2RAW_VERSION}/udp2raw_binaries.tar.gz"
ARG UDPSPEEDER_URL="https://github.com/wangyu-/UDPspeeder/releases/download/${UDPSPEEDER_VERSION}/speederv2_binaries.tar.gz"

RUN wget -O udp2raw.tar.gz ${UDP2RAW_URL} && tar -zxvf udp2raw.tar.gz udp2raw_amd64 -C /tmp/ && mv /tmp/udp2raw_amd64 /usr/bin/udp2raw && rm -f udp2raw.tar.gz
RUN wget -O speederv2.tar.gz ${UDPSPEEDER_URL} && tar -zxvf speederv2.tar.gz speederv2_amd64 -C /tmp/ && mv /tmp/speederv2_amd64 /usr/bin/speederv2 && rm -f speederv2.tar.gz

ENTRYPOINT ["udp2raw -s -l0.0.0.0:8585 -r127.0.0.1:8388 -k jason --raw-mode faketcp --cipher-mode none --auth-mode none --keep-rule -a", "&&", "speederv2 -s -l127.0.0.1:8388 -r127.0.0.1:29900 -k "jason" -f2:4 --timeout 0"]

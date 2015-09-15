FROM alpine:3.2
MAINTAINER Bitnami <containers@bitnami.com>

RUN apk add --update wget libstdc++ bash && \
    wget --no-check-certificate "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk" && \
    wget --no-check-certificate "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-bin-2.21-r2.apk" && \
    apk add --allow-untrusted glibc-2.21-r2.apk glibc-bin-2.21-r2.apk && \
    /usr/glibc/usr/bin/ldconfig /lib /usr/glibc/usr/lib && \
    wget --no-check-certificate -O /usr/bin/gosu "https://github.com/tianon/gosu/releases/download/1.4/gosu-amd64" && \
    chmod +x /usr/bin/gosu && \
    rm glibc-2.21-r2.apk glibc-bin-2.21-r2.apk && \
    apk del wget && \
    rm /var/cache/apk/*

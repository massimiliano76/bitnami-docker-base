FROM alpine:3.2
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_PREFIX=/opt/bitnami \
    S6_OVERLAY_VERSION=1.14.0.4

RUN apk add --update libstdc++ bash ca-certificates sudo curl coreutils && \
    curl -LO "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk" && \
    curl -LO "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-bin-2.21-r2.apk" && \
    curl -LO "http://nl.alpinelinux.org/alpine/edge/testing/x86_64/shadow-4.2.1-r3.apk" && \
    apk add --allow-untrusted glibc-2.21-r2.apk glibc-bin-2.21-r2.apk shadow-4.2.1-r3.apk && \
    /usr/glibc/usr/bin/ldconfig /lib /usr/glibc/usr/lib && \
    curl -LO https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz && \
    tar -zxf s6-overlay-amd64.tar.gz -C / && \
    curl -o /usr/bin/gosu "https://github.com/tianon/gosu/releases/download/1.4/gosu-amd64" && \
    chmod +x /usr/bin/gosu && \
    addgroup bitnami && \
    adduser -h /home/bitnami -s /bin/bash -D -G bitnami -g "" bitnami && \
    echo "bitnami ALL=NOPASSWD: ALL" >> /etc/sudoers && \
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
    rm glibc-2.21-r2.apk glibc-bin-2.21-r2.apk shadow-4.2.1-r3.apk s6-overlay-amd64.tar.gz && \
    rm /var/cache/apk/*

COPY rootfs/ /

FROM alpine:3.18 AS builder
ARG STUNNEL_VERSION=5.74

RUN apk add --no-cache build-base linux-headers openssl-dev openssl-libs-static wget tar

WORKDIR /src
RUN wget https://www.stunnel.org/downloads/stunnel-${STUNNEL_VERSION}.tar.gz && \
    tar -xzf stunnel-${STUNNEL_VERSION}.tar.gz && \
    cd stunnel-${STUNNEL_VERSION} && \
    sed -i 's/^stunnel_LDFLAGS = /&-all-static /' src/Makefile.in && \
    export CFLAGS='-Os -fomit-frame-pointer -pipe' && \
    ./configure \
        --prefix=/usr/local \
        --sysconfdir=/etc \
        --localstatedir=/var \
        --disable-fips \
        --disable-shared \
        --enable-static \
        --disable-silent-rules && \
    make && \
    strip src/stunnel && \
    mv src/stunnel /stunnel

FROM alpine:3.18

RUN mkdir -p /etc/stunnel
COPY --from=builder /stunnel /usr/local/bin/stunnel
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 8443
ENTRYPOINT ["/entrypoint.sh"]
#!/bin/sh
set -e

# Default to Docker host + port 22 if not explicitly set
: "${STUNNEL_ACCEPT:=8443}"
: "${STUNNEL_DEST_HOST:=host.docker.internal}"
: "${STUNNEL_DEST_PORT:=22}"
: "${STUNNEL_CONNECT:=$STUNNEL_DEST_HOST:$STUNNEL_DEST_PORT}"
: "${STUNNEL_SERVICE:=ssh}"
: "${STUNNEL_DEBUG:=7}"
: "${STUNNEL_CERT:=/etc/stunnel/stunnel.pem}"

# Create config directory if missing
mkdir -p /etc/stunnel

# Generate stunnel.conf
cat <<EOF > /etc/stunnel/stunnel.conf
foreground = yes
debug = $STUNNEL_DEBUG
cert = $STUNNEL_CERT

[$STUNNEL_SERVICE]
accept = $STUNNEL_ACCEPT
connect = $STUNNEL_CONNECT
EOF

echo "[stunnel] Starting with config:"
cat /etc/stunnel/stunnel.conf

exec stunnel /etc/stunnel/stunnel.conf
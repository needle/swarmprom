#!/bin/sh
set -e

HASHED=$(caddy hash-password --plaintext "${ADMIN_PASSWORD}")

cat > /etc/caddy/Caddyfile <<EOF
{
    admin off
}

:9090 {
    basic_auth /* {
        ${ADMIN_USER} ${HASHED}
    }
    reverse_proxy prometheus:9090
}

:9093 {
    basic_auth /* {
        ${ADMIN_USER} ${HASHED}
    }
    reverse_proxy alertmanager:9093
}

:9094 {
    basic_auth /* {
        ${ADMIN_USER} ${HASHED}
    }
    reverse_proxy karma:8080
}

:3000 {
    reverse_proxy grafana:3000
}
EOF

caddy run --config /etc/caddy/Caddyfile --adapter caddyfile

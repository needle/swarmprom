#!/bin/sh
set -e

# Generate bcrypt hash for the admin password
HASHED_PASSWORD=$(caddy hash-password --plaintext "${ADMIN_PASSWORD}")

# Create Caddyfile with hashed password
cat > /etc/caddy/Caddyfile <<EOF
{
    admin off
}

:9090 {
    basic_auth /* {
        ${ADMIN_USER} ${HASHED_PASSWORD}
    }
    reverse_proxy prometheus:9090
}

:9093 {
    basic_auth /* {
        ${ADMIN_USER} ${HASHED_PASSWORD}
    }
    reverse_proxy alertmanager:9093
}

:9094 {
    basic_auth /* {
        ${ADMIN_USER} ${HASHED_PASSWORD}
    }
    reverse_proxy karma:8080
}

:3000 {
    reverse_proxy grafana:3000
}
EOF

# Start Caddy
exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile

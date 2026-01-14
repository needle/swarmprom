#!/bin/sh
set -e

# Create Caddyfile for Docker daemon metrics proxy
cat > /etc/caddy/Caddyfile <<EOF
{
    admin off
}

:9323 {
    reverse_proxy ${DOCKER_GWBRIDGE_IP}:9323
}
EOF

# Start Caddy
exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile

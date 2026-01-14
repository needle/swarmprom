# Caddy v2 proxy for Docker daemon metrics
# Update this version periodically for security patches
FROM caddy:2.8.4-alpine

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

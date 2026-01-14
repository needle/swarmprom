# Prometheus with custom entrypoint for dynamic job configuration
# Update this version periodically for security patches
# https://hub.docker.com/r/prom/prometheus/tags/
FROM prom/prometheus:v2.54.1

ENV WEAVE_TOKEN=none

COPY conf /etc/prometheus/

ENTRYPOINT [ "/etc/prometheus/docker-entrypoint.sh" ]
CMD        [ "--config.file=/etc/prometheus/prometheus.yml", \
             "--storage.tsdb.path=/prometheus" ]

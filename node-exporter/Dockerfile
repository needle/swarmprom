# Node Exporter with custom entrypoint for Docker Swarm node metadata
# Update this version periodically for security patches
FROM prom/node-exporter:v1.8.2

ENV NODE_ID=none

USER root

COPY conf /etc/node-exporter/

ENTRYPOINT  [ "/etc/node-exporter/docker-entrypoint.sh" ]
CMD [ "/bin/node_exporter" ]

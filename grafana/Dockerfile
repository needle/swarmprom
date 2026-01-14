# Grafana with pre-provisioned dashboards for Docker Swarm monitoring
# Update this version periodically for security patches
# https://hub.docker.com/r/grafana/grafana/tags/
FROM grafana/grafana:11.4.0

COPY datasources /etc/grafana/provisioning/datasources/
COPY swarmprom_dashboards.yml /etc/grafana/provisioning/dashboards/
COPY dashboards /etc/grafana/dashboards/

ENV GF_SECURITY_ADMIN_PASSWORD=admin \
    GF_SECURITY_ADMIN_USER=admin \
    GF_PATHS_PROVISIONING=/etc/grafana/provisioning/

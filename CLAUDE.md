# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Swarmprom is a Docker Swarm monitoring stack combining Prometheus, Grafana, cAdvisor, Node Exporter, Alert Manager, and Unsee. It uses DNS-based service discovery to automatically detect and scrape metrics from all Swarm nodes.

## Deployment Commands

Deploy with Caddy reverse proxy (basic setup):
```bash
ADMIN_USER=admin \
ADMIN_PASSWORD=admin \
SLACK_URL=https://hooks.slack.com/services/TOKEN \
SLACK_CHANNEL=devops-alerts \
SLACK_USER=alertmanager \
docker stack deploy -c docker-compose.yml mon
```

Deploy with Traefik and HTTPS:
```bash
export ADMIN_USER=admin
export ADMIN_PASSWORD=changethis
export HASHED_PASSWORD=$(openssl passwd -apr1 $ADMIN_PASSWORD)
export DOMAIN=example.com
docker stack deploy -c docker-compose.traefik.yml swarmprom
```

Deploy with Weave Cloud integration:
```bash
TOKEN=<WEAVE-TOKEN> \
ADMIN_USER=admin \
ADMIN_PASSWORD=admin \
docker stack deploy -c weave-compose.yml mon
```

## Architecture

### Docker Compose Files
- `docker-compose.yml` - Main stack with Caddy as reverse proxy, uses `net` and `needle-db` overlay networks
- `docker-compose.traefik.yml` - Alternative stack using Traefik with automatic HTTPS via Let's Encrypt
- `weave-compose.yml` - Stack with Weave Cloud integration for external metrics storage

### Service Components
- **prometheus** - Metrics database (port 9090), runs on manager nodes, 24h default retention
- **grafana** - Visualization (port 3000), uses custom `needleops/grafana` image in main compose
- **alertmanager** - Alert dispatcher (port 9093), configured to send to Zenduty webhook
- **unsee** - Alert manager dashboard (port 9094)
- **cadvisor** - Container metrics collector, deployed globally
- **node-exporter** - Host metrics collector, deployed globally with node metadata
- **dockerd-exporter** - Docker daemon metrics via Caddy proxy, deployed globally
- **caddy** - Reverse proxy with basic auth for Prometheus/Alertmanager/Unsee

### Key Configuration Files
- `prometheus/conf/prometheus.yml` - Prometheus scrape configs using DNS service discovery
- `prometheus/rules/swarm_node.rules.yml` - Node-level alerts (CPU >75%, memory >93%, disk >85%)
- `prometheus/rules/swarm_task.rules.yml` - Container/task alerts, including custom stack monitoring
- `alertmanager/conf/alertmanager.yml` - Alert routing (currently Zenduty webhook)
- `caddy/Caddyfile` - Reverse proxy routing with basic auth
- `grafana/datasources/prometheus.yaml` - Grafana datasource config

### Grafana Dashboards
Located in `grafana/dashboards/`:
- `swarmprom-nodes-dash.json` - Docker Swarm nodes monitoring
- `swarmprom-services-dash.json` - Docker Swarm services monitoring
- `swarmprom-prometheus-dash.json` - Prometheus stats
- `node-exporter-full_rev1.json` - Detailed node exporter metrics
- `partner-purchases.json`, `partner-visits.json` - Custom dashboards

## Service Discovery

Prometheus uses DNS service discovery to find exporters via Docker Swarm's internal DNS:
- `tasks.node-exporter` on port 9100
- `tasks.cadvisor` on port 8080
- `tasks.dockerd-exporter` on port 9323

Node-exporter generates `node_meta` metric containing node ID and hostname, enabling PromQL queries to correlate metrics with actual Swarm nodes instead of overlay IPs.

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| ADMIN_USER | admin | Basic auth username |
| ADMIN_PASSWORD | admin | Basic auth password |
| PROMETHEUS_RETENTION | 24h | Prometheus data retention |
| SLACK_URL | - | Slack webhook URL |
| SLACK_CHANNEL | general | Slack channel |
| SLACK_USER | alertmanager | Slack username |
| DOMAIN | - | Domain for Traefik setup |
| HASHED_PASSWORD | - | APR1-hashed password for Traefik |

## Adding Custom Scrape Targets

Add additional services to Prometheus via the `JOBS` environment variable:
```yaml
prometheus:
  environment:
    - JOBS=mongo-exporter:9216 kafka-exporter:9216
```

Services must be attached to the `mon_net` network or Prometheus must be attached to their network.

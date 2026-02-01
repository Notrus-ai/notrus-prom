# Notrus Prometheus

Prometheus monitoring and alerting for Notrus application.

## Overview

This repository contains Prometheus configuration for:
- Scraping metrics from Notrus services (API, Webhook)
- Evaluating alert rules for application health
- Forwarding alerts to Alertmanager

## Files

- **prometheus.yml** - Main Prometheus configuration
- **alert_rules.yml** - Alert rules for application monitoring
- **Dockerfile** - Container image for deployment

## Alert Categories

### Application Health
- Service down detection (API, Webhook)
- High error rates (>5%)
- High latency (95th/99th percentile)

### Resource Usage
- CPU usage (warning at 85%, critical at 95%)
- Memory usage (warning at 85%, critical at 95%)
- Disk usage (warning at 80%, critical at 90%)

### Container Health
- High resource consumption
- Frequent restarts
- Unexpected container termination

### Database
- Connection pool exhaustion
- Slow queries
- Database connectivity issues

### Network
- High network traffic
- Network errors

## Configuration

### Environment Variables

- `NOTRUS_API_TARGET` - Target for API metrics scraping (default: api.notrus.ai)

### Scrape Targets

```yaml
- notrus-api: api.notrus.ai:443/metrics
- notrus-webhook: api.notrus.ai:443/webhook/metrics
```

## Deployment

### Using Docker

```bash
docker build -t notrus-prometheus .
docker run -p 9090:9090 notrus-prometheus
```

### Railway/Other Platforms

Deploy using the Dockerfile. Ensure:
1. Alertmanager is accessible at: `notrus-prom-alertmanager.railway.internal:9093`
2. Metrics endpoints are accessible from the Prometheus instance

## Testing

### Validate Configuration

```bash
# Check prometheus.yml syntax
promtool check config prometheus.yml

# Check alert rules
promtool check rules alert_rules.yml
```

### Query Alerts

```bash
# List all active alerts
curl http://localhost:9090/api/v1/alerts

# Check specific metric
curl 'http://localhost:9090/api/v1/query?query=up{job="notrus-api"}'
```

## Customizing Alerts

Edit `alert_rules.yml` to modify thresholds or add new alerts:

```yaml
- alert: CustomAlert
  expr: metric_name > threshold
  for: 5m
  labels:
    severity: warning
    service: notrus-custom
  annotations:
    summary: "Short description"
    description: "Detailed description with {{ $value }}"
```

## Troubleshooting

### Targets Not Scraping

1. Check target status: https://prometheus.notrus.ai/targets
2. Verify network connectivity to targets
3. Check if metrics endpoints return data:
   ```bash
   curl https://api.notrus.ai/metrics
   ```

### Alerts Not Firing

1. Check rule evaluation: https://prometheus.notrus.ai/rules
2. Verify query returns data in Graph view
3. Check `for` duration hasn't elapsed yet
4. Verify Alertmanager connectivity

### Alertmanager Not Receiving Alerts

1. Check Alertmanager target in Prometheus config
2. View Alertmanager status: https://prometheus.notrus.ai/status
3. Check logs for connection errors

## Related Repositories

- **notrus-prom-alertmanager** - Alert routing and notifications
- **notrus-observability** - Grafana dashboards and log-based alerts
- **notrus-infra2** - Infrastructure components (Grafana, Loki)

## Documentation

See [ALERTING_SETUP.md](../notrus-infra2/ALERTING_SETUP.md) in notrus-infra2 for complete alerting setup guide.

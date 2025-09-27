FROM prom/prometheus:latest
ADD prometheus.yml /etc/prometheus/
ADD alert_rules.yml /etc/prometheus/
EXPOSE 9090
USER root
ARG NOTRUS_API_TARGET=https://api.notrus.ai
ARG NOTRUS_WEB_TARGET=https://web.notrus.ai

#!/bin/bash

# Enable swap
sudo fallocate -l 8G /swapfile
sudo dd if=/dev/zero of=/swapfile bs=1024 count=8388608
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# cd /tmp
cd /home/ubuntu

# Update, Upgrade and Packages Installing
apt-get -yqq update
DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade

# Install packages
apt-get update
apt-get install -y docker.io git \
prometheus-snmp-exporter prometheus-node-exporter \
prometheus-blackbox-exporter prometheus-alertmanager \
prometheus-pushgateway cadvisor


# Hostname
INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
hostnamectl set-hostname ${function}-$INSTANCE_ID

mkdir -p /opt/alertmanager /opt/grafana/data /opt/prometheus/data /opt/prometheus/bin /opt/prometheus/etc

#--------------------------------------------------------------------------------------------------------
cat <<EOF > /etc/prometheus/alertmanager.yml
route:
    receiver: 'slack'
receivers:
    - name: 'slack'
      slack_configs:
          - send_resolved: true
            text: "{{ .CommonAnnotations.description }}"
            username: '${external_label}'
            channel: '#<channel-name>'
            api_url: 'https://hooks.slack.com/services/<webhook-id>'
EOF
#--------------------------------------------------------------------------------------------------------
cat <<EOF > /etc/prometheus/prometheus.yml
global:
  scrape_interval:     15s
  evaluation_interval: 15s
  external_labels:
      monitor: '${external_label}'
      environment: '${external_label}'
rule_files:
  - "alert.rules"
scrape_configs:
  - job_name: 'nodeexporter'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9100']
  - job_name: 'cadvisor'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:8080']
  - job_name: 'prometheus'
    scrape_interval: 10s
    static_configs:
      - targets: ['localhost:9090']
  - job_name: 'pushgateway'
    scrape_interval: 10s
    honor_labels: true
    static_configs:
      - targets: ['localhost:9091']
  - job_name: 'ec2_nodeexporter'
    ec2_sd_configs:
      - region: us-east-2
        port: 9100
alerting:
  alertmanagers:
  - scheme: http
    static_configs:
    - targets: 
      - 'localhost:9093'
EOF
#--------------------------------------------------------------------------------------------------------
cat <<EOF > /etc/prometheus/alert.rules
groups:
- name: targets
  rules:
  - alert: monitor_service_down
    expr: up == 0
    for: 30s
    labels:
      severity: critical
    annotations:
      summary: "Monitor service non-operational"
      description: "Service {{ $labels.instance }} is down."
- name: host
  rules:
  - alert: high_cpu_load
    expr: node_load1 > 1.5
    for: 30s
    labels:
      severity: warning
    annotations:
      summary: "Server under high load"
      description: "Docker host is under high load, the avg load 1m is at {{ $value}}. Reported by instance {{ $labels.instance }} of job {{ $labels.job }}."
  - alert: high_memory_load
    expr: (sum(node_memory_MemTotal_bytes) - sum(node_memory_MemFree_bytes + node_memory_Buffers_bytes + node_memory_Cached_bytes) ) / sum(node_memory_MemTotal_bytes) * 100 > 85
    for: 30s
    labels:
      severity: warning
    annotations:
      summary: "Server memory is almost full"
      description: "Docker host memory usage is {{ humanize $value}}%. Reported by instance {{ $labels.instance }} of job {{ $labels.job }}."
  - alert: high_storage_load
    expr: (node_filesystem_size_bytes{fstype="aufs"} - node_filesystem_free_bytes{fstype="aufs"}) / node_filesystem_size_bytes{fstype="aufs"}  * 100 > 85
    for: 30s
    labels:
      severity: warning
    annotations:
      summary: "Server storage is almost full"
      description: "Docker host storage usage is {{ humanize $value}}%. Reported by instance {{ $labels.instance }} of job {{ $labels.job }}."
EOF
#--------------------------------------------------------------------------------------------------------
# Apps configuration
#cd /opt; wget https://github.com/prometheus/prometheus/releases/download/v2.34.0/prometheus-2.34.0.linux-amd64.tar.gz
#tar -xf prometheus-2.34.0.linux-amd64.tar.gz
#mv prometheus-2.34.0.linux-amd64 /opt/prometheus/bin
#
#cat <<EOF > /opt/prometheus/etc/alert.rules
#[Unit]
#Description=Prometheus Service
#After=network.target
#
#[Service]
#Type=simple
#WorkingDirectory=/opt/prometheus
#ExecStart=/opt/prometheus/bin/prometheus --web.enable-lifecycle --web.external-url="https://prometheus-${external_label}" --storage.tsdb.max-block-duration=2h --storage.tsdb.min-block-duration=2h --config.file=/opt/prometheus/etc/prometheus.yml --storage.tsdb.path=/opt/prometheus/data
#Restart=always
#
#[Install]
#WantedBy=multi-user.target
#EOF

chmod 777 /opt/grafana/data

docker run -d --publish-all --network=host --restart=always --name grafana \
-e "GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-simple-json-datasource" \
-v /opt/grafana/data:/var/lib/grafana \
grafana/grafana:9.2.2

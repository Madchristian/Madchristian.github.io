---
layout: post
title: "Grafana Dashboard for Apple Content Cache? Sure!"
date: 2025-03-06 16:52:26 +0000
categories: Grafana Apple-Content-Cache Dashboard Monitoring
tags: grafana apple-content-cache dashboard monitoring
image:
  path: https://images.cstrube.de/blog/images/Apple-Content-Cache-Grafana-Dashboard/0001-Apple-Content-Cache-Grafana-Dashboard-96c062b0-a057-408f-a5ea-73f9c4a50133.webp
  lqip: data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAkACQAAD/2wBDAAICAgICAQICAgIDAgIDAwYEAwMDAwcFBQQGCAcJCAgHCAgJCg0LCQoMCggICw8LDA0ODg8OCQsQERAOEQ0ODg7/2wBDAQIDAwMDAwcEBAcOCQgJDg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg7/wAARCAAMABQDASIAAhEBAxEB/8QAFwAAAwEAAAAAAAAAAAAAAAAAAAMFCf/EACQQAAICAgAEBwAAAAAAAAAAAAECAwQAERIhMWFBU4GRodHS/8QAFgEBAQEAAAAAAAAAAAAAAAAAAQID/8QAGREAAgMBAAAAAAAAAAAAAAAAABEC8PES/9oADAMBAAIRAxEAPwDHqetHHc4XJ1wg7WMsenfGTVhHXiIkYoXIAaLmPTpint2BM6l1YBeRMSkj4xItTxlSrIeN9kGFCN+3bNlO4CKAq1HRWFm3rXkD9YZKmu2El0DGeXjAn1hhzO4Sj//Z
---

# Setting Up Prometheus and Grafana with GitHub Packages and Docker Compose

## Introduction

This guide will walk you through the process of setting up a Grafana + Prometheus monitoring stack to track the performance of Apple’s Content Caching service. You’ll learn how to download and install a .pkg file from my GitHub repository, configure the necessary files, and seamlessly import a pre-built Grafana dashboard to visualize key metrics.

Why Monitor Apple’s Content Caching?

Apple’s Content Caching optimizes network performance by storing and serving software updates, apps, and other Apple content locally. This reduces bandwidth usage, speeds up downloads, and enhances efficiency across multiple devices. However, ensuring the cache is performing optimally requires proper monitoring—especially in larger environments, where issues like bandwidth bottlenecks or cache misses can impact performance.

How Does This Monitoring Stack Work?
	•	A custom daemon collects real-time metrics from the Apple Content Cache and exposes them via HTTP (Port 9200).
	•	Prometheus scrapes these metrics and stores them for analysis.
	•	Grafana visualizes this data, providing insights into cache performance, bandwidth savings, and potential issues.

Requirements & Deployment Recommendations

To run the Apple Content Cache, a Mac is required, as this feature is exclusive to macOS.

For deploying the Grafana + Prometheus monitoring stack, you have two options:
	•	You can run the Docker Compose stack directly on your Mac using Podman.
	•	However, for a more reliable and headless setup, I recommend deploying the stack on a Linux VM or a Raspberry Pi 4 or 5 with at least 4GB of RAM and installed Docker and Docker Compose.

By the end of this guide, you’ll have a fully functional monitoring solution that provides real-time insights into the Apple Content Cache on your macOS device. Let’s get started! This compose is a minimal setup, you can add traefik for reverse proxy, and other services like Loki for log aggregation.

---

### 1. Download and Install the .pkg File from GitHub

If the repository provides a .pkg file as a release artifact, follow these steps to download and install it.

Find the .pkg in [GitHub Releases](https://github.com/Madchristian/ACCpromAdapterDaemon/releases/tag/latest) ,download and install.

This will install the ACCpromAdapterDaemon on your Mac. This daemon will collect metrics from the Apple Content Cache and expose them to Prometheus over HTTP Port 9200.

### 2. Set Up the Prometheus + Grafana Stack with Docker Compose on your Linux Server

Now, let’s create a Prometheus + Grafana stack using Docker Compose.
I assume you have Docker and Docker Compose installed on your server. If not, you can follow the official installation guide for [Docker](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/).

Create a new directory for your monitoring stack and navigate to it:

```bash
sudo mkdir -p /srv/grafana-prometheus-stack
cd /srv/grafana-prometheus-stack
```

Create a new file named `docker-compose.yml` and paste the following configuration:

```yaml
services:
  prometheus:
    container_name: prometheus
    image: prom/prometheus:latest
    ports:
      - 9090:9090
    volumes:
      - ./prometheus:/etc/prometheus
      - prometheus-data:/prometheus
    restart: unless-stopped
    command: --web.enable-lifecycle  --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.retention.time=90d

  alertmanager:
    container_name: alertmanager
    image: prom/alertmanager:latest
    ports:
      - 9093:9093
    volumes:
      - ./alertmanager:/etc/alertmanager
    command:
      - '--config.file=/etc/alertmanager/alertmanager.yml'
    restart: unless-stopped

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    user: "1000"
    volumes:
    - grafana-data:/var/lib/grafana
    # - ./config/grafana.ini:/etc/grafana/grafana.ini # Uncomment this line if you want to use a custom configuration file
    ports:
      - "3000:3000"
    restart: always
    env_file: grafana.env
    mem_limit: 2000m
    mem_reservation: 300m
  
volumes:
  prometheus-data:
  grafana-data:
```

Create a new directory named `prometheus` and a new file named `prometheus.yml` inside it:

```bash
mkdir prometheus
cd prometheus
touch prometheus.yml
```

Paste the following configuration into the `prometheus.yml` file:

```yaml

global:
  scrape_interval: 60s # Set the scrape interval to every 60 seconds. Default is every 1 minute.
  evaluation_interval: 60s # Evaluate rules every 60 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).
 
# Alertmanager configuration
alerting:
  alertmanagers:
    - static_configs:
        - targets:
          - alertmanager:9093

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  - "alerts.yml"
  # - "second_rules.yml"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

  - job_name: 'apple-content-cache'
    scrape_interval: 60s
    static_configs:
      - targets: ['insert_IP_apple_content_cache:9200']
      labels:
        group: 'apple-content-cache'
        location: 'datacenter-1'
  
  - job_name: 'more-content-caches'
    scrape_interval: 60s
    static_configs:
      - targets: ['insert_IP_apple_content_cache:9100']
      labels:
        group: 'apple-content-cache'
        location: 'datacenter-2'
```

Create a file named `alerts.yml` in the same directory and paste the following configuration:

```yaml
groups:
  - name: content-cache-alerts
    rules:
      - alert: HighRequestsFromClient
        expr: sum(rate(acc_zrequestsfromclient[5m])) > 100
        for: 1m
        labels:
          severity: warning
        annotations:
          summary: "High requests from client"
          description: "The number of requests from clients is high."
```

cd back to the root directory of the monitoring stack:

```bash
cd /srv/grafana-prometheus-stack
```

run the following command to start the monitoring stack:

```bash
docker-compose up -d
```

You should see the Prometheus, Alertmanager, and Grafana containers starting up.

### 3. Configure Prometheus to Scrape Metrics from the Apple Content Cache

Now, let’s configure Prometheus to scrape metrics from the Apple Content Cache. 
First, add the prometheus data source to Grafana:

1. Open your browser and navigate to `http://your_server_ip:3000`.
2. Log in with the default credentials (admin/admin).
3. Click on the gear icon on the left sidebar and select `Data Sources`.
4. Click on `Add data source`.
5. Select `Prometheus` from the list of data sources.
6. In the `HTTP` section, enter `http://prometheus:9090` as the URL.
7. Click on `Save & Test`.
8. You should see a green notification that says `Data source is working`.
9. Click on the `Explore` tab to test the Prometheus query.

Next, import the pre-built Grafana dashboard for the Apple Content Cache:

1. Open your browser and navigate to `http://your_server_ip:3000`.
2. Log in with the default credentials (admin/admin).
3. Click on the `+` icon on the left sidebar and select `Import`.
4. Copy the contents of the [Apple Content Cache Grafana Dashboard JSON file](https://github.com/Madchristian/ACCpromAdapterDaemon.git)
5. Paste the JSON content into the `Import via panel json` text area.
6. Click on `Load`.
7. Select the Prometheus data source you added earlier from the dropdown list.
8. Click on `Import`.
9. You should see the Apple Content Cache Grafana dashboard with metrics visualizations.

That’s it! You now have a fully functional monitoring stack to visualize metrics from the Apple Content Cache in Grafana.

### Conclusion

In this guide, we walked you through how to download and install a .pkg file from a GitHub repository, set up a Prometheus + Grafana monitoring stack using Docker Compose, configure the necessary files, and import a pre-built Grafana dashboard for the Apple Content Cache.

You can fine-tune the monitoring stack by adding more metrics, alerts, and visualizations to suit your needs.

![0002-Apple-Content-Cache-Grafana-Dashboard-6bc2b61b-a16f-4099-ad32-0f5d4ff8ac83.jpg!](https://images.cstrube.de/blog/images/Apple-Content-Cache-Grafana-Dashboard/0002-Apple-Content-Cache-Grafana-Dashboard-6bc2b61b-a16f-4099-ad32-0f5d4ff8ac83.webp){: w="800" h="600" lqip="data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAkACQAAD/2wBDAAICAgICAQICAgIDAgIDAwYEAwMDAwcFBQQGCAcJCAgHCAgJCg0LCQoMCggICw8LDA0ODg8OCQsQERAOEQ0ODg7/2wBDAQIDAwMDAwcEBAcOCQgJDg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg7/wAARCAAIABQDASIAAhEBAxEB/8QAFwABAAMAAAAAAAAAAAAAAAAAAAQFCf/EACEQAAICAQIHAAAAAAAAAAAAAAECAAMEMUEREhMhI2Gx/8QAFwEAAwEAAAAAAAAAAAAAAAAAAAECBP/EABYRAQEBAAAAAAAAAAAAAAAAAAABEf/aAAwDAQACEQMRAD8AyRvxarM/n6BclRxKEHb3KxsdC58L67UpETXiEsJWtaKqVgBRrj9/kREQj//Z" }

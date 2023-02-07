---
title: bind9 DNS Server
date: 2023-02-07 22:00:00 +0100
categories: [Homelab,Server,DNS]
tags: [servers,linux,vm,dns]     # TAG names should always be lowercase
---


> docker-compose.yml {: .prompt-danger }


```yaml
version: "3"

services:
  bind9:
    container_name: dnsserver
    image: ubuntu/bind9:latest
    environment:
      - BIND9_USER=root
      - TZ=Europe/Berlin
    ports:
      - "53:53/tcp"
      - "53:53/udp"
    volumes:
      - ./config:/etc/bind
      - ./cache:/var/cache/bind
      - ./records:/var/lib/bind
    restart: unless-stopped
```

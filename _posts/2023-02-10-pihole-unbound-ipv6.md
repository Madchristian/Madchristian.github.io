---
title: Pi-Hole mit Unbound / IPv4 und IPv6
date: 2023-02-10 22:00:00 +0100
categories: [Homelab]
tags: [servers,pihole,dns,docker]     # TAG names should always be lowercase
---
# Pi-Hole Adblocker in Docker mit Unbound und IPv4 / IPv6

![pihole-screenshot](https://images.cstrube.de/web/blog/2023-02-10-pihole-unbound/pihole-screenshot1.png)
---
## Mein Setup
Bei mir läuft der primäre DNS-Server auf einem Raspberry Pi 4 in einem Docker Container zusammen mit Unbound. Da ich den Pi-Hole auch für die lokale Namesauflösung verwende (*.local.cstrube.de) und mir Traeffik hierfür über Let's Encrypt SSL Zerifikate erstellt brauche ich die Möglichkeit zusammen IPv4 und IPv6 auflösen zu können. 

## 1. Statische IP Adresse 
Dem Raspberry Pi mit netplan eine statische IPv4 einrichten:

```bash
sudo ip a
```

```
christian@rpi1:~/pihole-unbound$ sudo ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether **:**:**:**:**:** brd ff:ff:ff:ff:ff:ff
    inet 10.0.50.10/24 brd 10.0.50.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 2a02:8071:50d1:2465:e65f:1ff:fe46:efae/64 scope global dynamic mngtmpaddr noprefixroute 
       valid_lft 86345sec preferred_lft 14345sec
    inet6 fe80::****:***:****:****/64 scope link 
       valid_lft forever preferred_lft forever
```

unter 2: eth0: sieht man hier den Netzwerknamen. Anschließend erstellen wir eine Datei die wir **01-netcfg.yaml** nenen im **/etc/netplan** Verzeichniss.

```bash
sudo nano /etc/netplan/01-netcfg.yaml
```

```yaml
 network:
    ethernets:
        eth0:
            addresses:
            - 10.0.50.10/24
            dhcp4: false
            gateway4: 10.0.50.1
            nameservers:
                addresses:
                - 1.1.1.1
                - 1.0.0.1
                search:
                - workgroup
    version: 2
```
Hier habe ich DHCP deaktiviert und als DNS Server Cloudflares DNS Server gesetzt (1.1.1.1 und 1.0.0.1)

Als nächstes kommen folgende zwei Befehle:
```bash
sudo netplan generate
sudo netplan apply
```

## 2. Port 53 freimachen
Da ich auf dem Raspberry Pi ein Ubuntu 22.04 laufen lasse musste ich als nächstes den Port 53 freiräumen. Dieser wird standardmäßig von resolved belegt.
Dafür editiert man die **/etc/systemd/resolved.conf** Datei:
```bash
sudo nano /etc/systemd/resolved.conf
```
Hier wird unter #DNSStubListener=yes die # weggenommen und von =yes auf =no geändert. Siehe Beispiel:
```c
[Resolve]
# Some examples of DNS servers which may be used for DNS= and FallbackDNS=:
# Cloudflare: 1.1.1.1#cloudflare-dns.com 1.0.0.1#cloudflare-dns.com 2606:4700:4700::1111#cloudflare-dns.com 260>
# Google:     8.8.8.8#dns.google 8.8.4.4#dns.google 2001:4860:4860::8888#dns.google 2001:4860:4860::8844#dns.go>
# Quad9:      9.9.9.9#dns.quad9.net 149.112.112.112#dns.quad9.net 2620:fe::fe#dns.quad9.net 2620:fe::9#dns.quad>
#DNS=
#FallbackDNS=
#Domains=
#DNSSEC=no
#DNSOverTLS=no
#MulticastDNS=no
#LLMNR=no
#Cache=no-negative
#CacheFromLocalhost=no
DNSStubListener=no
#DNSStubListenerExtra=
#ReadEtcHosts=yes
#ResolveUnicastSingleLabel=no
```
Nach einem Neustart ist Port 53 frei für unseren Docker Container

## 3. Docker installieren

Als erstes die Abhängigkeiten installieren:
```bash
sudo apt-get install apt-transport-https ca-certificates software-properties-common -y
```
Anschließend Docker mit dem offiziellen Script installieren
```bash
curl -fsSL get.docker.com -o get-docker.sh && sh get-docker.sh
```
Jetzt fügen wir noch unseren User der Docker Gruppe hinzu, damit können wir Docker ohne sudo ausführen:
```bash
sudo usermod -aG docker pi
```
## 4. Docker für IPv6 vorbereiten:
Out of the Box unterstützt Docker kein IPv6, deswegen müssen wir eine **/etc/docker/daemon.json** Datei erstellen:
```json
{
  "ipv6": true,
  "fixed-cidr-v6": "fe80::/64"
}
```
>Laut offizieller Dokumentation braucht man das nicht, allerdings hatte ich ohne die Datei Probleme damit
{: .prompt-danger }

Einmal Docker Daemon neustarten:
```bash
sudo systemctl restart docker
```
Als nächstes brauchen wir iptables damit das Docker Netzwerk IPv6 Traffic empfängt:
```bash
sudo ip6tables -t nat -A POSTROUTING -s fe80::/64 ! -o docker0 -j MASQUERADE
```
und damit die Änderungen nach einem Neustart nicht verloren gehen gibts das hier:
```bash
sudo apt install iptables-persistent netfilter-persistent
```
Einfach mit "yes" bestätigen

## 5. Setup Pi-Hole Container
Da ich ein Fan von Docker Compose bin habe ich hier als erstes eine **.env** Datei mit den Variablen erstellt:
```json
FTLCONF_LOCAL_IPV4=10.0.50.10
TZ=Europe/Berlin
WEBPASSWORD=sehrsicherespasswort
REV_SERVER=true
REV_SERVER_DOMAIN=local.cstrube.de
REV_SERVER_TARGET=10.0.10.1
REV_SERVER_CIDR=10.0.0.0/16
HOSTNAME=pihole-unbound
DOMAIN_NAME=pihole-unbound.local.cstrube.de
PIHOLE_WEBPORT=80
WEBTHEME=default-dark
```
Die Datei liegt im gleichen Verzeichniss wie die **docker-compose.yml**:
```yaml
version: '3.0'

volumes:
  etc_pihole-unbound:

services:
  pihole:
    container_name: pihole-unbound
    image: cbcrowe/pihole-unbound:latest
    hostname: ${HOSTNAME}
    domainname: ${DOMAIN_NAME}
    ports:
      - 443:443/tcp
      - 53:53/tcp
      - 53:53/udp
      - ${PIHOLE_WEBPORT:-80}:80/tcp 
    environment:
      - FTLCONF_LOCAL_IPV4=${FTLCONF_LOCAL_IPV4}
      - TZ=${TZ:-UTC}
      - WEBPASSWORD=${WEBPASSWORD}
      - WEBTHEME=${WEBTHEME:-default-dark}
      - REV_SERVER=${REV_SERVER:-false}
      - REV_SERVER_TARGET=${REV_SERVER_TARGET}
      - REV_SERVER_DOMAIN=${REV_SERVER_DOMAIN}
      - REV_SERVER_CIDR=${REV_SERVER_CIDR}
      - PIHOLE_DNS_=127.0.0.1#5335
      - DNSSEC="true"
      - DNSMASQ_LISTENING=single
      - ServerIPv6="fe80::***:****:****:****"
    volumes:
      - etc_pihole-unbound:/etc/pihole:rw
      - ./etc_pihole_dnsmasq-unbound:/etc/dnsmasq.d:rw
    restart: unless-stopped
```
>Wichtig hierbei: ServerIPv6="..." mit der eigenen ausgelesenen Link-Local Adresse aus "ip a" ausfüllen!
{: .prompt-danger }

`/pihole-unbound/docker-compose.yml`
{: .filepath}

Den Container starten wir dann mit:
```bash
docker compose up -d --force-recreate
```
Jetzt muss nur noch im Router der DNS Server auf die IPv4 und IPv6 Adresse des Raspberry Pi geändert werden.
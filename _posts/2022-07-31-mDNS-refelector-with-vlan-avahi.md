---
title: mDNS mit VLAN nutzen (z.B. Raspberry Pi)
date: 2022-07-31 15:00:00
categories: [Homelab]
tags: [pi, mdns, vlan, avahi, raspberry]
---

## Einleitung

In diesem Beitrag erfahren Sie, wie Sie mDNS (Multicast DNS) in einem VLAN-Setup nutzen können, insbesondere mit einem Raspberry Pi. Diese Anleitung hilft Ihnen, Probleme wie den fehlenden Zugriff auf Drucker und Apple Airplay zu beheben, die häufig in Netzwerken mit VLANs auftreten.

## Probleme

- Apple Airprint funktioniert nicht.
- Zugriff auf Drucker und Apple Airplay ist nicht möglich.
- Omada SDN unterstützt derzeit keinen mDNS-Reflektor.

## Setup

### Hardware-Anforderungen

Ein Raspberry Pi sollte im "Client"-Netzwerk mit getaggtem WLAN und IOT LAN VLAN (bei mir 70, 72 und 40) über eth0 verbunden sein.

### Installation des Avahi-Daemons

Führen Sie die folgenden Befehle aus, um den Avahi-Daemon zu installieren:

```bash
sudo apt update && sudo apt upgrade
sudo apt install avahi-daemon
```

### Daemon starten

Starten Sie den Daemon mit einem der folgenden Befehle:

```bash
/etc/init.d/avahi-daemon start
```
oder:
```bash
sudo systemctl start avahi-daemon
```

Um den Daemon beim Booten automatisch zu starten, verwenden Sie:

```bash
sudo systemctl enable avahi-daemon
```

## Avahi-Daemon konfigurieren

Öffnen Sie die Konfigurationsdatei:

```bash
sudo nano /etc/avahi/avahi-daemon.conf
```

Fügen Sie die folgenden Einstellungen hinzu oder ändern Sie diese:

```conf
[server]
use-ipv4=yes
use-ipv6=yes

[wide-area]
enable-wide-area=yes

[reflector]
enable-reflector=yes
#reflect-ipv=no
#reflect-filters=_airplay._tcp.local,_raop._tcp.local
```

## VLAN im Network Interface

Erstellen Sie eine Konfigurationsdatei für die VLANs:

```bash
sudo nano /etc/network/interfaces.d/vlans
```

Fügen Sie die folgenden VLAN-Konfigurationen hinzu:

```yml
# WLAN
auto eth0.70
iface eth0.70 inet manual
  vlan-raw-device eth0

# IOT WLAN/LAN
auto eth0.72
iface eth0.72 inet manual
  vlan-raw-device eth0

# Client VLAN
auto eth0.40
iface eth0.40 inet manual
  vlan-raw-device eth0
```

## Abschluss

Starten Sie den Avahi-Daemon neu, um die Änderungen zu übernehmen:

```bash
sudo systemctl restart avahi-daemon
```

### Überprüfung der Netzwerkkonfiguration

Überprüfen Sie die Netzwerkkonfiguration mit dem folgenden Befehl:

```bash
ip a
```

Sie sollten Ausgaben ähnlich der folgenden sehen:

```
eth0.70@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    inet 10.0.70.155/24 brd 10.0.70.255 scope global dynamic noprefixroute eth0.70
...
```

## Fazit

Mit dieser Konfiguration sollten Airprint und Airplay über getrennte VLANs hinweg funktionieren.
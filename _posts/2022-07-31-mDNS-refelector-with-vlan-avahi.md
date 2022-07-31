---
title: mDNS mit VLAN nutzen (zb. Raspberry Pi)
date: 2022-07-31 15:00:00
categories: [homelab,raspberry,AVAHI]
tags: [servers,homelab,pi,mdns,avahi,vlan]
---

# Problem: IOT WLAN / WLAN sind in verschiedenen VLAN

- Apple Airprint geht nicht
- Zugriff auf Drucker und Apple Airplay nicht möglich
- Omada SDN kann (noch) kein mDNS Refelector

## Setup

Ein Raspberry Pi im "Client" Netz mit getaggten WLAN und IOT LAN VLAN (bei mit 70,72 und 40) mit eth0 verbunden.

Avahi Daemin installieren:
```bash
sudo apt update && sudo apt upgrade

sudo apt install avahi-daemon
```

Daemon starten:
```bash
/etc/init.d/avahi-daemon start
```
oder:
```bash
sudo systemctl start avahi-daemon
```
anschließend für Automatischen Start:
```bash
sudo systemctl enable avahi-daemon
```
sudo nano /etc/avahi/avahi-daemon.conf
```conf
[server]
..
use-ipv4=yes
use-ipv6=yes
..

[wide-area]
enable-wide-area=yes

[reflector]
enable-reflector=yes
#reflect-ipv=no
#reflect-filters=_airplay._tcp.local,_raop._tcp.local

```
---
sudo nano /etc/network/interfaces.d/vlans
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

zum Schluss noch:
```bash
sudo systemctl restart avahi.daemon
```

```bash
$bash: ip a
...
4: eth0.70@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether b8:27:eb:0c:2e:ef brd ff:ff:ff:ff:ff:ff
    inet 169.254.84.86/16 brd 169.254.255.255 scope global noprefixroute eth0.70
       valid_lft forever preferred_lft forever
    inet6 fe80::ba27:ebff:fe0c:2eef/64 scope link 
       valid_lft forever preferred_lft forever
...
````


Airprint und Airplay funktionieren über getrennte VLAN hinweg.
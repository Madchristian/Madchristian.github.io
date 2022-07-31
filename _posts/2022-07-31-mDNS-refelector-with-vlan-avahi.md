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
## Avahi-Daemon konfigurieren
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
## VLAN im Network Interface
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
eth0.70@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether b8:27:eb:0c:2e:ef brd ff:ff:ff:ff:ff:ff
    inet 10.0.70.155/24 brd 10.0.70.255 scope global dynamic noprefixroute eth0.70
       valid_lft 5364sec preferred_lft 4464sec
    inet6 fd47:776d:f64c:49d0:caba:69cd:3878:66ce/64 scope global deprecated dynamic mngtmpaddr noprefixroute 
       valid_lft 999sec preferred_lft 0sec
    inet6 2a02:908:4c24:62c7:597c:3ee7:71ab:c300/64 scope global dynamic mngtmpaddr noprefixroute 
       valid_lft 86003sec preferred_lft 14003sec
    inet6 fe80::ba27:ebff:fe0c:2eef/64 scope link 
       valid_lft forever preferred_lft forever
5: eth0.30@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether b8:27:eb:0c:2e:ef brd ff:ff:ff:ff:ff:ff
    inet 10.0.30.100/24 brd 10.0.30.255 scope global dynamic noprefixroute eth0.30
       valid_lft 5359sec preferred_lft 4459sec
    inet6 2a02:908:4c24:62c3:2c4:3aab:6b43:4cc9/64 scope global dynamic mngtmpaddr noprefixroute 
       valid_lft 86328sec preferred_lft 14328sec
    inet6 fe80::6b73:b6bc:98bc:33a1/64 scope link 
       valid_lft forever preferred_lft forever
    inet6 fe80::ba27:ebff:fe0c:2eef/64 scope link 
       valid_lft forever preferred_lft forever
6: eth0.20@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether b8:27:eb:0c:2e:ef brd ff:ff:ff:ff:ff:ff
    inet 10.0.20.101/24 brd 10.0.20.255 scope global dynamic noprefixroute eth0.20
       valid_lft 5365sec preferred_lft 4465sec
    inet6 2a02:908:4c24:62c2:1247:382:5e75:6c24/64 scope global dynamic mngtmpaddr noprefixroute 
       valid_lft 86081sec preferred_lft 14081sec
    inet6 fe80::3ace:6f97:dffc:2acc/64 scope link 
       valid_lft forever preferred_lft forever
7: eth0.72@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether b8:27:eb:0c:2e:ef brd ff:ff:ff:ff:ff:ff
    inet 10.0.72.3/24 brd 10.0.72.255 scope global dynamic noprefixroute eth0.72
       valid_lft 5366sec preferred_lft 4466sec
    inet6 2a02:908:4c24:62c8:a73a:6449:c13d:f9dd/64 scope global dynamic mngtmpaddr noprefixroute 
       valid_lft 86087sec preferred_lft 14087sec
    inet6 fe80::68c9:c9c4:da3b:aa23/64 scope link 
       valid_lft forever preferred_lft forever
...
```
ipv4 und ipv6

## Fazit
Airprint und Airplay funktionieren über getrennte VLAN hinweg.
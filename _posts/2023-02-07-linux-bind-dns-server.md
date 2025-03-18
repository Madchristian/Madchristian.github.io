---
title: bind9 DNS Server
date: 2023-02-07 22:00:00 +0100
categories: [Homelab, VMs]
tags: [servers,dns,linux]     # TAG names should always be lowercase
---
## Ein eigener DNS-Server mit BIND9 bietet folgende Vorteile:

>    Kontrolle über die Namensauflösung: Ein eigener DNS-Server gibt Ihnen die Kontrolle über die Namensauflösung und ermöglicht es Ihnen, Ihre eigenen Domänen und IP-Adressen zu verwalten.

>    Verringerung der Latenzzeiten: Ein lokaler DNS-Server kann schnellere Antwortzeiten bieten, da er nicht auf externe DNS-Server angewiesen ist, um Anfragen zu beantworten.

>    Höhere Verfügbarkeit: Ein eigener DNS-Server kann eine höhere Verfügbarkeit gewährleisten, da er nicht auf externe Server angewiesen ist und ein Ausfall dieser Server die Namensauflösung nicht beeinträchtigt.

>    Schutz vor Angriffen: Ein eigener DNS-Server kann dazu beitragen, das Netzwerk vor DNS-basierten Angriffen zu schützen, indem er für eine sichere Übertragung der Daten sorgt.

>    Flexibilität: BIND9 ist ein leistungsstarkes und flexibles System, das anpassbar ist, um spezifische Anforderungen und Bedürfnisse zu erfüllen.

---
### Umsetzung:

Basis ist ein Ubuntu 22.04 LXC in meinem Proxmox Cluster, vorbereitet mit Docker Engine und Docker Compose

### Ordnerstruktur:

`/bind9/docker-compose.yml`
{: .filepath}
`/bind9/records/`
{: .filepath}
`/bind9/cache/`
{: .filepath}

> docker-compose.yml
{: .prompt-info }


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

---
`/bind9/config/named.conf`
{: .filepath}
> Achtung, hier die eigenen IP Adressen eintragen
{: .prompt-danger }
```conf
acl internal {
    10.0.10.0/24;
    10.0.20.0/24;
    10.0.30.0/24;
    10.0.70.0/24;
};

options {
    forwarders {
        1.1.1.1;
        1.0.0.1;
    };
    allow-query { internal; };
};

zone "local.cstrube.de" IN {
    type master;
    file "/etc/bind/local.cstrube.zone";
};
```

---
`/bind9/config/local.cstrube.zone`
{: .filepath}
> local.cstrube.zone
{: .prompt-info }
```conf
$TTL 2d

$ORIGIN local.cstrube.de.

@               IN      SOA     ns.local.cstrube.de. info.cstrube.de. (
                                2023070222      ; serial
                                12h             ; refresh
                                15m             ; retry
                                3w              ; expire
                                2h              ; minimum ttl
                                )

                IN      NS      ns.local.cstrube.de.

ns              IN      A       10.0.20.11

; -- add dns records below

pvecm2      IN      A       10.0.10.72
pvecm3      IN      A       10.0.10.79
```
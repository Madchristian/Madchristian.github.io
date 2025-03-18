---
title: Konfiguration von Jekyll als systemd-Dienst auf Ubuntu
date: 2022-08-01 12:00:00
categories: [Homelab]
tags: [pi,mdns,nginx,webserver,raspberry,ubuntu,systemd,jekyll]
image:
  path: https://images.cstrube.de/uploads/original/0b/a9/a3d3482ad394aff292827d15199d.webp
  lqip: data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAYEBAQFBAYFBQYJBgUGCQsIBgYICwwKCgsKCgwQDAwMDAwMEAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/2wBDAQcHBw0MDRgQEBgUDg4OFBQODg4OFBEMDAwMDBERDAwMDAwMEQwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/wAARCAAPABQDAREAAhEBAxEB/8QAGAAAAgMAAAAAAAAAAAAAAAAAAgMEBgf/xAArEAABAwMBAw0AAAAAAAAAAAACARESAAMEIQUxUQYTFSIjM0FTYnGCodH/xAAYAQEAAwEAAAAAAAAAAAAAAAACAAMEAf/EACQRAAEDAgQHAAAAAAAAAAAAAAEAAhEDEgQiUWETIUFSkrLi/9oADAMBAAIRAxEAPwDL8jbmZiLbW1klbt3EIU3aKK6u4lxrokkgIVC1oBIm5KLlnti2CAOQpiSusVD76lMMdqqDiGaHy+VK6ay25yfbThL1Si8dz0J5StVuaN1Xci4tyzaHJtmAgpwJ0R3XXfwqCQTCFVrXAXGIlDbDCTzF+QflMOfoqODS7vVFPIk0C76Tv4zePvVfRbJzTuv/2Q==
---

## Einleitung

In diesem Beitrag erfahren Sie, wie Sie Jekyll als systemd-Dienst auf einem Ubuntu-Server einrichten. Dies ist besonders nützlich, um sicherzustellen, dass Ihre Jekyll-Website immer läuft, selbst nach einem Neustart des Servers.

## Voraussetzungen

Bevor Sie beginnen, stellen Sie sicher, dass Sie folgende Voraussetzungen erfüllen:

- Einen Ubuntu-Server, eine VM oder einen LXC-Container
- Ruby und Bundler installiert (siehe [Anleitung](https://jekyllrb.com/tutorials/using-jekyll-with-bundler/))
- Ein Jekyll-Projekt, beispielsweise basierend auf dieser Vorlage: [jekyll-docs-site @timothystewart6](https://technotim.live/posts/jekyll-docs-site/)

## Konfiguration

### Schritt 1: Umgebungsvariable festlegen

Öffnen Sie die `.bashrc` oder `.bash_profile` Datei in Ihrem Home-Verzeichnis und fügen Sie die folgende Zeile hinzu:

```bash
export JEKYLL_ENV=production
```

### Schritt 2: Konfiguration laden

Führen Sie den folgenden Befehl aus, um die neue Konfiguration zu laden:

```bash
source ~/.bashrc
```

### Schritt 3: Gems installieren

Navigieren Sie in Ihr Jekyll-Projektverzeichnis und führen Sie die folgenden Befehle aus, um alle notwendigen Gems mit Bundler zu installieren:

```bash
bundle config set --local path 'vendor/bundle'
bundle install
```

Dies sorgt dafür, dass alle Gems in einem Unterordner (`vendor/bundle`) Ihres Projekts installiert werden.

### Schritt 4: systemd-Service-Datei erstellen

Erstellen Sie eine systemd-Service-Datei für Jekyll. Erstellen Sie die Datei `/etc/systemd/system/jekyll.service` und fügen Sie den folgenden Inhalt ein:

```ini
[Unit]
Description=Jekyll Build
After=network.target

[Service]
Type=simple
User=christian
WorkingDirectory=/home/IHR_BENUTZERNAME/GITHUB_USERNAME.github.io
Environment="BUNDLE_PATH=/home/IHR_BENUTZERNAME/GITHUB_USERNAME.github.io/vendor/bundle"
Environment="GEM_HOME=/home/IHR_BENUTZERNAME/.gem/ruby/3.0.0"
Environment="JEKYLL_ENV=production"
ExecStart=/bin/bash -lc '/home/IHR_BENUTZERNAME/gems/bin/bundle exec /home/IHR_BENUTZERNAME/gems/bin/jekyll build -w'
CPUQuota=20%

[Install]
WantedBy=multi-user.target
```

**Wichtig:** Ersetzen Sie `IHR_BENUTZERNAME` durch Ihren tatsächlichen Benutzernamen und `GITHUB_USERNAME` durch Ihren GitHub-Benutzernamen.

> Hinweis: Die Zeile `CPUQuota=20%` sorgt dafür, dass der Dienst maximal 20% der verfügbaren CPU-Zeit verbraucht. Dies ist besonders sinnvoll, wenn Sie den Dienst auf einem Raspberry Pi betreiben, um die Systemressourcen zu schonen.

### Schritt 5: Dienst aktivieren und starten

Aktivieren und starten Sie den Dienst mit den folgenden Befehlen:

```bash
sudo systemctl enable jekyll.service
sudo systemctl start jekyll.service
```

## Fehlerbehebung

Falls Sie auf Probleme stoßen, überprüfen Sie bitte:

- Sind alle Pfade korrekt?
- Hat der angegebene Benutzer die notwendigen Berechtigungen?

Bei spezifischen Gem-Problemen kann es hilfreich sein, diese manuell zu installieren oder verschiedene Versionen zu testen. Nutzen Sie außerdem die Logs zur Fehlersuche:

```bash
sudo journalctl -u jekyll.service -xe
```

### Dienststatus prüfen

Nachdem der Dienst gestartet wurde, kann sein Status mit folgendem Befehl überprüft werden:

```bash
systemctl status jekyll.service
```

Beispielausgabe:

```
● jekyll.service - Jekyll Build
     Loaded: loaded (/etc/systemd/system/jekyll.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2025-03-17 08:04:20 UTC; 23h ago
   Main PID: 116 (bundle)
      Tasks: 8 (limit: 76807)
     Memory: 153.9M
        CPU: 55.466s
     CGroup: /system.slice/jekyll.service
             ├─116 "/home/christian/gems/bin/jekyll build -w"
             └─510 /home/christian/Madchristian.github.io/vendor/bundle/ruby/3.0.0/gems/sass-embedded-1.63.6/ext/sas>
```

Falls der Dienst unerwartet stoppt oder nicht startet, überprüfe die Logs mit:

```bash
sudo journalctl -u jekyll.service -xe
```

Zusätzlich sollten etwaige **Konflikte beim Generieren der Website** behoben werden, wie sie in der Logausgabe erscheinen:

```
Conflict: The following destination is shared by multiple files.
The written file may end up with unexpected contents.
```

Dies kann auftreten, wenn mehrere Dateien denselben Zielpfad haben. Stelle sicher, dass keine doppelten Kategorien oder Tags existieren.

Falls weiterhin Probleme auftreten, könnte ein erneutes Bereinigen und Bauen der Site helfen:

```bash
bundle exec jekyll clean
bundle exec jekyll build
```

Dieser Abschnitt hilft Nutzern, typische Probleme mit dem systemd-Dienst zu erkennen und zu beheben.

## Abschluss

Jetzt sollte Ihre Jekyll-Instanz erfolgreich auf dem Server laufen und nach einem Systemneustart automatisch wieder gestartet werden. Überprüfen Sie den Status des Dienstes jederzeit mit:

```bash
systemctl status jekyll.service
```

Mit diesen Schritten haben Sie eine robuste Konfiguration für Ihre Jekyll-Website unter systemd geschaffen.

---
title: Konfiguration von Jekyll als systemd-Dienst auf Ubuntu
date: 2022-08-01 12:00:00
categories: [homelab,NGINX,JEKYLL]
tags: [servers,homelab,pi,mdns,nginx,webserver]
---
# **selfhost** Jekyll

**Titel:** Konfiguration von Jekyll als systemd-Dienst auf Ubuntu 

**Einleitung**

Dieser Beitrag soll Ihnen zeigen, wie Sie Jekyll als einen systemd-Dienst auf einem Ubuntu-Server einrichten können. Dies ist besonders nützlich, wenn Sie eine Jekyll-Website hosten und sicherstellen möchten, dass sie immer läuft, auch nach einem Neustart des Servers.

**Voraussetzungen**

- Einen Ubuntu-Server, VM oder LXC-Container
- Ruby und Bundler installiert [Anleitung](https://jekyllrb.com/tutorials/using-jekyll-with-bundler/)
- Ein Jekyll-Projekt z.B. nach dieser Vorlage: [jekyll-docs-site @timothystewart6](https://technotim.live/posts/jekyll-docs-site/)

**Konfiguration**

Schritt 1: Zunächst sollten wir eine Umgebungsvariable für Jekyll festlegen. Dafür öffnen Sie die `.bashrc` oder `.bash_profile` Datei in Ihrem Home-Verzeichnis und fügen die folgende Zeile hinzu:

```bash
export JEKYLL_ENV=production
```

Schritt 2: Führen Sie `source ~/.bashrc` aus, um die neue Konfiguration zu laden.

Schritt 3: Installieren Sie alle notwendigen Gems mit Bundler. In Ihrem Jekyll-Projektverzeichnis führen Sie die folgenden Befehle aus:

```bash
bundle config set --local path 'vendor/bundle'
bundle install
```

Dies sorgt dafür, dass alle Gems in einem Unterordner (`vendor/bundle`) Ihres Projekts installiert werden.

Schritt 4: Erstellen Sie nun eine systemd-Service-Datei für Jekyll. Erstellen Sie die Datei `/etc/systemd/system/jekyll.service` und fügen Sie den folgenden Inhalt ein:

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
ExecStart=/bin/bash -lc '/home/IHR_BENUTERNAME/gems/bin/bundle exec /home/christian/gems/bin/jekyll build -w'
CPUQuota=20%

[Install]
WantedBy=multi-user.target
```

Ersetzen Sie `IHR_BENUTZERNAME` durch Ihren Benutzernamen und `PFAD/ZU/IHREM/JEKYLL_PROJEKT` durch den tatsächlichen Pfad zu Ihrem Jekyll-Projekt.

Ersetzen Sie `GITHUB_USERNAME` durch Ihren GitHub-Benutzernamen.

> CPUQuota=20%, der Dienst darf maximal 20% der Verfügbaren CPU Zeit verbrauchen, dies ist sinnvoll, wenn Sie den Dienst auf einem Raspberry Pi betreiben wollen, damit der Dienst nicht die ganze CPU Zeit verbraucht und andere Dienste nicht mehr reagieren können.
{: .prompt-info }

Schritt 5: Aktivieren und starten Sie den Dienst mit 
```bash
sudo systemctl enable jekyll.service
sudo systemctl start jekyll.service
```


**Fehlerbehebung**

Sollten Sie auf Probleme stoßen, überprüfen Sie, ob alle Pfade korrekt sind und ob der angegebene Benutzer die richtigen Berechtigungen hat. Bei spezifischen Gem-Problemen kann es hilfreich sein, diese manuell zu installieren oder verschiedene Versionen zu testen.

**Abschluss**

Jetzt sollten Sie eine laufende Jekyll-Instanz auf Ihrem Server haben, die nach einem Systemneustart automatisch wieder gestartet wird. Sie können den Status des Dienstes jederzeit mit `systemctl status jekyll.service` überprüfen. 

Um den Dienst du überwachen eignet sich auch wunderbar:
```bash
sudo journalctl -u jekyll.service -xe
```

---

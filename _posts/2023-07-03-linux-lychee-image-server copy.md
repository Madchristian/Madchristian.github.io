---
title: Einrichtung und Fehlerbehebung eines Lychee-Bilderservers
date: 2023-07-03 00:00:00 +0100
categories: [homelab,linux,lychee]
tags: [servers,homelab,nginx,webserver,lychee,linux]
image:
  path: https://images.cstrube.de/uploads/original/89/bd/b33eca3371ad2efec9085ca295ca.webp
  lqip: data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAYEBAQFBAYFBQYJBgUGCQsIBgYICwwKCgsKCgwQDAwMDAwMEAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/2wBDAQcHBw0MDRgQEBgUDg4OFBQODg4OFBEMDAwMDBERDAwMDAwMEQwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/wAARCAAPABQDAREAAhEBAxEB/8QAGAAAAgMAAAAAAAAAAAAAAAAAAgMEBgf/xAArEAABAwMBAw0AAAAAAAAAAAACARESAAMEIQUxUQYTFSIjM0FTYnGCodH/xAAYAQEAAwEAAAAAAAAAAAAAAAACAAMEAf/EACQRAAEDAgQHAAAAAAAAAAAAAAEAAhEDEgQiUWETIUFSkrLi/9oADAMBAAIRAxEAPwDL8jbmZiLbW1klbt3EIU3aKK6u4lxrokkgIVC1oBIm5KLlnti2CAOQpiSusVD76lMMdqqDiGaHy+VK6ay25yfbThL1Si8dz0J5StVuaN1Xci4tyzaHJtmAgpwJ0R3XXfwqCQTCFVrXAXGIlDbDCTzF+QflMOfoqODS7vVFPIk0C76Tv4zePvVfRbJzTuv/2Q==
---
Lychee ist eine großartige Open-Source-Lösung zur Verwaltung und Organisation Ihrer Fotos. In diesem Beitrag zeige ich Ihnen, wie Sie einen Lychee-Bilderserver einrichten und potenzielle Probleme beheben können.


## Schritt 1: Systemvoraussetzungen

Um Lychee zu installieren, stellen Sie sicher, dass Ihr Server folgendes vorweist:

- Ein Webserver wie Apache oder nginx.
- Eine Datenbank: MySQL (version > 5.7.8), MariaDB (version > 10.2), PostgreSQL (version > 9.2), oder SQLite3.
- PHP >= 8.0 mit entsprechenden PHP-Erweiterungen.
- Imagick-Extension für bessere Thumbnail-Generierung.


## Schritt 2: Lychee herunterladen und installieren

Beginnen wir mit dem Herunterladen von Lychee. Sie können Lychee direkt von GitHub klonen:

```bash
git clone https://github.com/LycheeOrg/Lychee.git
```

Wechseln Sie in das Verzeichnis und installieren Sie die erforderlichen Abhängigkeiten mit Composer:

```bash
cd Lychee
composer install --no-dev
```


## Schritt 3: Datenbank konfigurieren

Erstellen Sie eine neue Datenbank für Lychee und behalten Sie die Zugangsdaten bei. Sie benötigen diese, wenn Sie Lychee zum ersten Mal starten.
```bash
mysql -u root -p

CREATE DATABASE lychee;
CREATE USER 'lychee'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON lychee.* TO 'lychee'@'localhost';
FLUSH PRIVILEGES;
exit;
```


## Schritt 4: Nginx-Konfiguration

Hier ist ein einfaches Beispiel für eine Nginx-Konfigurationsdatei:

```
nginx

server {
    listen 80;
    server_name your-domain.com;

    root /path/to/your/lychee/public;
    index index.php;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php/php8.0-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PHP_VALUE "post_max_size=100M
                                upload_max_filesize=20M ";
    }
}
```

Vergessen Sie nicht, Ihren Domainnamen und den Pfad zu Ihrem Lychee-Verzeichnis zu ändern. Nachdem Sie Ihre Konfigurationsdatei eingerichtet haben, vergewissern Sie sich, dass Nginx und PHP-FPM korrekt konfiguriert sind und laufen.


## Schritt 5: Berechtigungen setzen

Vergewissern Sie sich, dass die Berechtigungen für Ihr Lychee-Verzeichnis korrekt gesetzt sind. Sie können dies mit den folgenden Befehlen erreichen:

```bash
sudo chown -R www-data:www-data /var/www/Lychee/
sudo find /var/www/Lychee/ -type d -exec chmod 775 {} \;
sudo find /var/www/Lychee/ -type f -exec chmod 664 {} \;
```


## Schritt 6: Lychee konfigurieren und nutzen

Öffnen Sie nun Ihren Webbrowser und navigieren Sie zu Ihrer Lychee-Website. Sie werden aufgefordert, eine Datenbank zu erstellen und einen Benutzernamen und ein Passwort zu wählen.
Troubleshooting

Manchmal könnten Sie auf einige Probleme stoßen. Hier sind einige gängige Lösungen:

    Fehler 502: Dieser Fehler tritt normalerweise auf, wenn Nginx versucht, mit dem PHP-FPM-Dienst zu kommunizieren und keine Antwort erhält. Überprüfen Sie, ob PHP-FPM läuft (systemctl status php8.1-fpm.service) und ob der Socket-Pfad in der Nginx-Konfigurationsdatei korrekt ist.

    Berechtigungsprobleme: Wenn Sie eine Fehlermeldung erhalten, dass bestimmte Verzeichnisse oder Dateien die falschen Berechtigungen haben, führen Sie die oben genannten chown und chmod Befehle erneut aus.

    Fehler beim Hochladen von Bildern: Wenn Sie Probleme beim Hochladen von Bildern haben, überprüfen Sie die PHP-Einstellungen in Ihrer Nginx-Konfigurationsdatei. Stellen Sie sicher, dass post_max_size und upload_max_filesize hoch genug eingestellt sind.


## Fazit

Mit diesen Schritten sollten Sie in der Lage sein, Lychee auf Ihrem Server zu installieren und zu konfigurieren. Bitte beachten Sie, dass die genaue Vorgehensweise je nach Ihrer spezifischen Serverkonfiguration variieren kann.

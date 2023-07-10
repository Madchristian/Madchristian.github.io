---
layout: post
title: Teilautomatisierung der Erstellung neuer Jekyll-Posts
date: 2023-07-08 00:00:00 +0100
categories: [Programming, Scripting]
tags: [servers,nginx,webserver,jekyll,automation,scripting,shell,bash]
author: "Christian Strube"
image:
  path: https://images.cstrube.de/uploads/original/89/bd/b33eca3371ad2efec9085ca295ca.webp
  lqip: data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAYEBAQFBAYFBQYJBgUGCQsIBgYICwwKCgsKCgwQDAwMDAwMEAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/2wBDAQcHBw0MDRgQEBgUDg4OFBQODg4OFBEMDAwMDBERDAwMDAwMEQwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/wAARCAAPABQDAREAAhEBAxEB/8QAGAAAAgMAAAAAAAAAAAAAAAAAAgMEBgf/xAArEAABAwMBAw0AAAAAAAAAAAACARESAAMEIQUxUQYTFSIjM0FTYnGCodH/xAAYAQEAAwEAAAAAAAAAAAAAAAACAAMEAf/EACQRAAEDAgQHAAAAAAAAAAAAAAEAAhEDEgQiUWETIUFSkrLi/9oADAMBAAIRAxEAPwDL8jbmZiLbW1klbt3EIU3aKK6u4lxrokkgIVC1oBIm5KLlnti2CAOQpiSusVD76lMMdqqDiGaHy+VK6ay25yfbThL1Si8dz0J5StVuaN1Xci4tyzaHJtmAgpwJ0R3XXfwqCQTCFVrXAXGIlDbDCTzF+QflMOfoqODS7vVFPIk0C76Tv4zePvVfRbJzTuv/2Q==
---
Das Skript, das wir entwickelt haben, zielt darauf ab, den Prozess der Erstellung eines neuen Blog-Posts in Jekyll zu automatisieren, insbesondere das Optimieren von Bildern und das Generieren der dazugehörigen Base64-Low-Quality-Image-Placeholders (LQIP).

Hier ist ein Überblick über das Skript und seine Funktionen:

**1. Vorbereitung:**
Das Skript definiert zunächst die notwendigen Verzeichnisse und stellt sicher, dass sie existieren. Es erstellt sie, wenn sie nicht vorhanden sind.

**2. Beobachtung des Verzeichnisses:**
Es verwendet `inotifywait`, um das Verzeichnis, in das neue Bilder hochgeladen werden, auf neue Dateien zu überwachen. Es reagiert auf die Ereignisse "create" und "moved_to" und verarbeitet jede neue `.jpg`-Datei, die in das Verzeichnis hinzugefügt wird.

**3. Post-Erstellung:**
Für jedes hochgeladene Bild wird ein neuer Blog-Post erstellt, basierend auf dem Verzeichnisnamen des Bildes. Das Skript generiert eine Jekyll-kompatible Markdown-Datei mit Metadaten wie dem Titel, dem Datum, den Kategorien, den Tags und dem Autor. Es erstellt auch ein spezielles `image`-Metadatenfeld, das den Pfad zur Bilddatei und die Base64-Zeichenfolge des LQIP enthält.

**4. Bildoptimierung:**
Jedes Bild wird kopiert und optimiert, um eine kleinere Dateigröße zu erreichen. Danach wird das optimierte Bild in das WebP-Format konvertiert und in ein spezielles Verzeichnis verschoben, auf das der Nginx-Webserver Zugriff hat.

**5. Erzeugung von LQIPs:**
Zusätzlich wird eine niedrigauflösende Version des Bildes erzeugt, in Base64 umgewandelt und in einer Datei gespeichert. Dies wird verwendet, um die LQIPs für den Blog-Post zu erzeugen, die während des Ladens der Seite angezeigt werden, bevor das eigentliche Bild geladen wird.

**6. Räumt auf:**
Nachdem alle Schritte erfolgreich abgeschlossen wurden, löscht das Skript die temporären und optimierten Bilder.

**7. Synchronisierung:**
Schließlich verwendet das Skript `rsync`, um die generierten Base64-Dateien und Blog-Post-Dateien an einen entfernten Server zu übertragen.

Alles in allem dient dieses Skript dazu, den Prozess der Erstellung von Blog-Posts zu optimieren und zu automatisieren. Es reduziert den Aufwand, der mit der manuellen Optimierung von Bildern und der Erstellung von LQIPs verbunden ist, und vereinfacht die Erstellung von Blog-Posts in Jekyll.

Hier ist das vollständige Skript. Denken Sie daran, dass Sie die Variablen und Pfade an Ihre eigene Umgebung anpassen müssen:

```bash
#!/bin/bash
dir=/var/www/Lychee/public/uploads/import
base64dir=$dir/base64
imagedir=/var/www/public/blog/images
postsdir=/home/user/posts
remote_dir=user@ip-webserver:~/newpost

mkdir -p $base64dir $imagedir $postsdir || { echo "Failed to create directories"; exit 1; }

inotifywait -m $dir -e create -e moved_to --format '%w%f' -r |
    while read file; do
        relative_path=${file#$dir/}
        if [[ $file =~ .jpg$ ]] && [[ $file != *_optimized.jpg ]]; then
            echo "Processing $file..."

            postname=$(basename $(dirname $file))
            filename=$(basename $file .jpg)

            postdir=$imagedir/$postname
            mkdir -p $postdir || { echo "Failed to create directory $postdir"; continue; }

            mdfile=$postsdir/$(date +'%Y-%m-%d')-${postname}.md
            if [[ ! -e $mdfile ]]; then
                echo "---" > $mdfile || { echo "Failed to create $mdfile"; continue; }
                echo "title: \"Title Here\"" >> $mdfile
                echo "date: $(date +'%Y-%m-%d %H:%M:%S %z')" >> $mdfile
                echo "categories: ['category1', 'category2']" >> $mdfile
                echo "tags: ['tag1', 'tag2']" >> $mdfile
                echo "author: \"Your Name\"" >> $mdfile
                echo "---" > $mdfile
            fi

            optimized=$dir/${relative_path%.*}_optimized.jpg
            rsync -avP $file $optimized || { echo "Failed to copy $file"; continue; }
            jpegoptim -s $optimized || { echo "Failed to optimize $file"; continue; }
            webp=$postdir/${filename}.webp
            cwebp -q 80 $optimized -o $webp || { echo "Failed to convert $file to WebP"; continue; }

            base64file=$base64dir/${filename}_optimized.base64
            convert $optimized -resize 20 - | base64 > $base64file || { echo "Failed to convert $file to Base64"; continue; }

            image_path="https://images.example.com/blog/images/$postname/${filename}.webp"
            base64_string=$(cat $base64file)
            echo "image:" >> $mdfile || { echo "Failed to write to $mdfile"; continue; }
            echo "  path: $image_path" >> $mdfile
            echo "  lqip: data:image/jpeg;base64,$base64_string" >> $mdfile

            [ -e "$optimized" ] && rm $optimized
            rsync -az -e 'ssh -o StrictHostKeyChecking=no' --delete $base64dir/ $remote_dir/ || { echo "Failed to rsync $base64dir/ to $remote_dir/"; continue; }
            rsync -az -e 'ssh -o StrictHostKeyChecking=no' --delete $postsdir/ $remote_dir/ || { echo "Failed to rsync $postsdir/ to $remote_dir/"; continue; }
            echo "$file processed successfully"
        fi
    done
```

Mit diesem Skript können Sie die Bilder in das `uploads/import`-Verzeichnis hochladen und das Skript überwacht dieses Verzeichnis, um automatisch einen neuen Blog-Post zu erstellen, das Bild zu optimieren und das LQIP zu generieren. 

>Bitte beachten Sie, dass Sie die korrekten Zugangsdaten für Ihren Remote-Server benötigen und dass die Befehle `jpegoptim`, `cwebp` und `convert` (Teil von ImageMagick) auf Ihrem Server installiert sein müssen, damit das Skript funktioniert.
{: .prompt-info }

---
Dies ist ein leistungsfähiges Skript, das den Prozess der Blog-Post-Erstellung in Jekyll erheblich vereinfacht und verbessert. Es erleichtert den Umgang mit Bildern und verbessert das Laden von Bildern auf Ihrer Website durch die Verwendung von LQIPs.
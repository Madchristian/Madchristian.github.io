---
layout: post
title: "Blog Update: Automatisierung der Bildoptimierung und WebP-Konvertierung"
date: 2023-07-09 21:47:49 +0000
categories: blog
tags: update blog jekyll bash script webp jpegoptim cwebp base64
author: "Christian Strube"
image:
  path: https://images.cstrube.de/blog/images/blog-update/blog-update.webp
  lqip: data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAICAgICAQICAgIDAgIDAwYEAwMDAwcFBQQGCAcJCAgHCAgJCg0LCQoMCggICw8LDA0ODg8OCQsQERAOEQ0ODg7/2wBDAQIDAwMDAwcEBAcOCQgJDg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg7/wAARCAAPABQDAREAAhEBAxEB/8QAFQABAQAAAAAAAAAAAAAAAAAABwb/xAAoEAABBAEDAwIHAAAAAAAAAAABAgMEBREGBxIAEyEiMQgUFSNBUWH/xAAYAQADAQEAAAAAAAAAAAAAAAADBQYCBP/EACQRAAIBAgUFAQEAAAAAAAAAAAECAwARBBIhMUETIlFxgbHR/9oADAMBAAIRAxEAPwCQ0ds/tZT7/Tr/AFlrlMCvprREyk05TzRZyZkY/cjOxFnixGaLZShTjye6laVp4jKeubEYiPCAifcaebjj3pzRIIHxFjEN9+LHn1rxTxWbfWerHHbfT8eioqV6YpqtrJcpLsyPG5BKuboHqSOKFggK9TqieCSAJHLHOivEALX9nXmqUF4mKyXO3zShDVMnUuldxbnTZmvMPVspUd5LDykJCx5P6JxkDJAPj2HWGJRirbijqFYXFDLO9Wwth8B1fo+o20nN77vhlVvrNlSE/LuJk8lFLriisocaGC22hCRkYzxHT9+gsGW3d/KRJ1jLe9hR/F3Eq6sfUVy3bJ9lIBS6hYLZzxGCB58pznPv0thWNSRLFmvt3FfyqCHEQRgmRc30j8qCtdz5E7UUyX3nsuuFZKXVjJP5OfJP9PRmhQsSq2Hi97fTvS+SdWclRYeK/9k=
---
 Wir haben ein Bash-Skript entwickelt und eingerichtet, das inotify verwendet, um neu hinzugefügte Bilder zu überwachen. Sobald ein neues Bild erkannt wird, optimiert das Skript das Bild mit `jpegoptim`, konvertiert es dann mit `cwebp` in das WebP-Format und erzeugt eine LQIP-Version des Bildes für eine verbesserte Seitendarstellung während des Ladens. 

1. **Erstellung von Markdown-Posts automatisieren:** Das Skript generiert zudem automatisch eine Markdown-Datei für jeden neuen Blog-Post, die in Jekyll verwendet wird. Diese Datei enthält Header-Informationen sowie Links zu den optimierten Bildern. 

2. **Implementierung von inotify für Dateilöschungen:** Wir haben versucht, `inotifywait` so einzurichten, dass es auf gelöschte Dateien reagiert und einen `rsync`-Befehl ausführt, um Änderungen zwischen lokalen und entfernten Verzeichnissen zu synchronisieren. Allerdings sind wir auf einige Herausforderungen gestoßen und haben letztendlich entschieden, `syncthing` für die Synchronisation zu verwenden.

3. **Einrichten von Syncthing für Dateisynchronisation:** Wir haben Syncthing auf dem Server installiert und konfiguriert, um Änderungen im Blog-Post-Verzeichnis in Echtzeit zu überwachen und zu synchronisieren. Dies hat den Vorteil, dass es bidirektional arbeitet und Dateiänderungen sowohl lokal als auch auf dem entfernten Server überwacht.

Zusammengefasst haben wir heute einen signifikanten Automatisierungsprozess implementiert, der die Arbeit mit Bildern in Jekyll-Posts stark vereinfacht. Dies wird nicht nur die Qualität und Performance der Website verbessern, sondern auch viel Zeit sparen, die sonst für manuelles Optimieren, Konvertieren und Hochladen der Bilder aufgewendet werden müsste.
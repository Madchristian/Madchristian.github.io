---
layout: post
title: "Parken App Updates 0.0.5"
date: 2023-07-30 22:23:49 +0000
categories: Swift App
tags: swiftui iOS app backend
image:
  path: https://images.cstrube.de/blog/images/swift-parken-app-0-0-5/parkenapp005.webp
  lqip: data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAIBAQIBAQICAgICAgICAwUDAwMDAwYEBAMFBwYHBwcGBwcICQsJCAgKCAcHCg0KCgsMDAwMBwkODw0MDgsMDAz/2wBDAQICAgMDAwYDAwYMCAcIDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/wAARCAAPABQDAREAAhEBAxEB/8QAGQAAAQUAAAAAAAAAAAAAAAAAAQQFBgcI/8QAJBAAAQQBAwUBAQEAAAAAAAAAAQIDBAURAAYSByEiMVEUCIH/xAAXAQADAQAAAAAAAAAAAAAAAAABAgME/8QAJREAAgEDAgUFAAAAAAAAAAAAAQIRAAMSBCExgaHR4RMiQZGS/9oADAMBAAIRAxEAPwDA8rq6nbgd/RuWbXmQEvMRmqz9PiR7580475ABz60i5OWJuFYJG0dqrcC2wgFpWlQZM/POhb/09YR61xul3VZS3FrB/PJqUtjGScFYWfIHGO2O5+aYqwG11unapq6E+6yvXvTxt/rFZz6CHIsJilSZDZWcAJGORAwP81WyxIMmd6GptqCpURInaqLtd2090uIZkqXHdjxm2FBEQODxz3zzH35rNheUnFZkk8a1M1hgubwQAOE8OdSCj6o19VVNRWrSYG2CSl0VoSvGE9jxeTnGPZyfI6oH1ERgPvxUTZ0pM+ofz5pDN3fHcajIhPyHWGWQgKdaDaieSj6BV9+6e2CActqF91OIQzAiv//Z
---
Liebes Tester Team,

in dieser Version sind einige Bugs gefixt worden. App Abstürze aus dem Background heraus sind behoben worden.

Folgende Neuerungen sind implementiert worden:

1. parken: oben wird jetzt die aktive Gruppe angezeigt, der Kennzeichenscanner vergleicht den Anfang des Kennzeichens mit der Liste aller möglichen Zulassungsbezirke, das sollte die Genauigkeit erhöhen. Das Scannen allgemein geht jetzt wesentlich schneller. 
2. Kartenansicht: Die Karte ist jetzt beim ersten öffnen auf Deutschland gezoomt, bei jedem weiteren öffnen auf das zuletzt hinzugefügte Fahrzeug
3. Fahrzeuge: In der Detailsansicht können jetzt Kennzeichen, FIN und Status angepasst werden, beim klicken auf speichern werden die Daten auf dem Server aktualisiert. Wenn das erfolgreich war werden die Daten auch auf dem Gerät aktualisiert. 
4. Profil: Gruppeneinladungen und Gruppe verlassen funktionieren jetzt wie vorgesehen.

Viel Spaß beim Ausprobieren, ich freue mich auf euer Feedback
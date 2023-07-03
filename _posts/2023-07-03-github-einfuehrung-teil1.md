---
title: Grundlagen zur Nutzung von Github Teil 1
date: 2023-07-03 8:00:00 +0100
categories: [homelab,linux,github]
tags: [github,git,linux]
image:
  path: https://images.cstrube.de/uploads/original/e7/4c/a9a3e34aebc4a74df044c95fa6db.webp
  lqip: data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAYEBAQFBAYFBQYJBgUGCQsIBgYICwwKCgsKCgwQDAwMDAwMEAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/2wBDAQcHBw0MDRgQEBgUDg4OFBQODg4OFBEMDAwMDBERDAwMDAwMEQwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/wAARCAAPABQDAREAAhEBAxEB/8QAGAAAAgMAAAAAAAAAAAAAAAAAAgMEBgf/xAArEAABAwMBAw0AAAAAAAAAAAACARESAAMEIQUxUQYTFSIjM0FTYnGCodH/xAAYAQEAAwEAAAAAAAAAAAAAAAACAAMEAf/EACQRAAEDAgQHAAAAAAAAAAAAAAEAAhEDEgQiUWETIUFSkrLi/9oADAMBAAIRAxEAPwDL8jbmZiLbW1klbt3EIU3aKK6u4lxrokkgIVC1oBIm5KLlnti2CAOQpiSusVD76lMMdqqDiGaHy+VK6ay25yfbThL1Si8dz0J5StVuaN1Xci4tyzaHJtmAgpwJ0R3XXfwqCQTCFVrXAXGIlDbDCTzF+QflMOfoqODS7vVFPIk0C76Tv4zePvVfRbJzTuv/2Q==
---
# Die Nutzung von GitHub: Ein umfassender Leitfaden

GitHub ist eine webbasierte Hosting-Plattform für die Versionsverwaltung Git. Es bietet eine Reihe von Funktionen, die das Arbeiten in Gruppen erleichtern und zur gemeinsamen Entwicklung von Software-Projekten genutzt werden. In diesem Blog-Beitrag gehen wir tief in die Nutzung von GitHub ein und erklären Begriffe wie Repository, Commit, Pull, Push, Stash und vieles mehr.

## GitHub Repository

Ein Repository (oder "Repo") ist ein Speicherort für ein Projekt. Es enthält alle Projektdateien und jede Änderung, die an diesen Dateien vorgenommen wird. Ein GitHub-Repository enthält nicht nur den Projektcode, sondern auch die Versionshistorie und weitere Informationen wie Issues, Projektboards und Aktionen.

Erstellen Sie ein neues Repository, indem Sie auf der GitHub-Hauptseite auf die Schaltfläche "New" klicken. Geben Sie Ihrem Repository einen Namen und eine Beschreibung. Sie können es öffentlich machen, damit jeder es sehen und daran arbeiten kann, oder privat, damit nur Sie und die von Ihnen eingeladenen Personen darauf zugreifen können.

## Git Commit

Ein "Commit" ist eine Änderung, die Sie an den Dateien in Ihrem Repository vornehmen. Jeder Commit hat eine eindeutige ID, die Sie verwenden können, um auf spezifische Änderungen zu verweisen. Ein Commit enthält auch eine Commit-Nachricht, die beschreibt, was in diesem Commit geändert wurde.

Um einen Commit zu erstellen, machen Sie zuerst Änderungen an den Dateien in Ihrem Repository. Wenn Sie fertig sind, können Sie mit dem Befehl `git add` die geänderten Dateien zur "Staging Area" hinzufügen. Danach können Sie mit `git commit -m "Ihre Nachricht"` einen neuen Commit mit Ihrer Änderung erstellen.

## Git Push

Mit dem Befehl "Push" laden Sie Ihre lokalen Änderungen in Ihr GitHub-Repository hoch. Der Befehl `git push origin master` beispielsweise lädt alle Änderungen, die Sie in Ihrem lokalen "master"-Branch gemacht haben, auf GitHub hoch.

## Git Pull

"Pull" ist der umgekehrte Vorgang zu "Push". Mit einem "Pull" holen Sie die neuesten Änderungen aus Ihrem GitHub-Repository und aktualisieren damit Ihren lokalen Code. Der Befehl dazu lautet `git pull origin master`, um die neuesten Änderungen vom "master"-Branch herunterzuladen.

## Git Stash

Mit dem Befehl `git stash` können Sie Änderungen, die Sie noch nicht committen möchten, vorübergehend beiseitelegen. Diese Änderungen werden gespeichert und können später wieder hervorgeholt werden. Das ist besonders nützlich, wenn Sie mitten in der Arbeit an einer Funktion sind und schnell zu einem anderen Branch wechseln müssen.

## Fazit

Das Arbeiten mit GitHub kann zu Beginn kompliziert erscheinen, aber mit ein wenig Übung wird es schnell zu einem mächtigen Werkzeug für die Softwareentwicklung. Die Befehle und Konzepte, die wir in diesem Blogbeitrag besprochen haben, sind die Grundlage für die Arbeit mit GitHub. Sie ermöglichen es Ihnen, Ihre Projekte effektiv zu verwalten, zusammen mit anderen zu arbeiten und
den Überblick über Ihre Änderungen zu behalten.

Wir hoffen, dass dieser Beitrag Ihnen einen guten Überblick über die Grundlagen von GitHub gegeben hat. Viel Spaß beim Coden!
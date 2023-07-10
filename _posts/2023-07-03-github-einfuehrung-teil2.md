---
title: Grundlagen zur Nutzung von Github Teil 2
date: 2023-07-03 16:00:00 +0100
categories: [Github]
tags: [git,commit,branch,merge,clone,push,pull]
image:
  path: https://images.cstrube.de/uploads/original/e7/4c/a9a3e34aebc4a74df044c95fa6db.webp
  lqip: data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAYEBAQFBAYFBQYJBgUGCQsIBgYICwwKCgsKCgwQDAwMDAwMEAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/2wBDAQcHBw0MDRgQEBgUDg4OFBQODg4OFBEMDAwMDBERDAwMDAwMEQwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/wAARCAAPABQDAREAAhEBAxEB/8QAGAAAAgMAAAAAAAAAAAAAAAAAAgMEBgf/xAArEAABAwMBAw0AAAAAAAAAAAACARESAAMEIQUxUQYTFSIjM0FTYnGCodH/xAAYAQEAAwEAAAAAAAAAAAAAAAACAAMEAf/EACQRAAEDAgQHAAAAAAAAAAAAAAEAAhEDEgQiUWETIUFSkrLi/9oADAMBAAIRAxEAPwDL8jbmZiLbW1klbt3EIU3aKK6u4lxrokkgIVC1oBIm5KLlnti2CAOQpiSusVD76lMMdqqDiGaHy+VK6ay25yfbThL1Si8dz0J5StVuaN1Xci4tyzaHJtmAgpwJ0R3XXfwqCQTCFVrXAXGIlDbDCTzF+QflMOfoqODS7vVFPIk0C76Tv4zePvVfRbJzTuv/2Q==
---
# Titel: "Grundlagen von GitHub: Von Repositories bis zu Commits und Branches"

Ein weiterer wichtiger Aspekt von GitHub sind die "Branches" und "Merges". Diese Konzepte sind essenziell für das Verständnis, wie die Entwicklung in Git organisiert wird.

## Branches in GitHub

Ein "Branch" ist eine unabhängige Linie der Entwicklung in Ihrem Projekt. Stellen Sie sich das wie einen parallelen Pfad vor, auf dem Sie arbeiten können, ohne die Hauptlinie der Entwicklung (üblicherweise "master" oder "main" genannt) zu beeinflussen. Jeder Branch hat seinen eigenen Verlauf von Commits und kann unabhängig von anderen Branches bearbeitet werden.

Ein neuer Branch wird oft erstellt, wenn Sie an einer neuen Funktion oder einem Bugfix arbeiten. So können Sie Änderungen vornehmen und testen, ohne den Hauptcode zu beeinträchtigen. Der Befehl `git branch` zeigt Ihnen alle vorhandenen Branches an, und mit `git branch <branch-name>` können Sie einen neuen Branch erstellen.

## Merges in GitHub

Wenn Sie Ihre Arbeit in einem Branch abgeschlossen haben und diese Änderungen in den Hauptzweig einfließen lassen wollen, führen Sie einen "Merge" durch. Bei einem Merge werden die Änderungen aus einem Branch in einen anderen übertragen.

Der Befehl `git merge <branch-name>` führt den angegebenen Branch in den aktuell aktiven Branch ein. Eventuelle Konflikte, die dabei auftreten (z.B. wenn in beiden Branches die gleiche Zeile in einer Datei geändert wurde), müssen manuell gelöst werden.

## Fazit

Branches und Merges sind zentrale Bestandteile der Arbeit mit Git und GitHub. Sie ermöglichen paralleles Arbeiten und erleichtern die Integration von Änderungen. Mit der Zeit werden Sie feststellen, dass die Nutzung von Branches und Merges den Arbeitsfluss erheblich erleichtern kann. 

Wir hoffen, dass dieser Blogbeitrag Ihnen dabei hilft, den vollen Nutzen aus GitHub zu ziehen. Bei weiteren Fragen oder Unklarheiten, zögern Sie nicht, einen Kommentar zu hinterlassen oder uns direkt zu kontaktieren. Viel Spaß beim Coden!
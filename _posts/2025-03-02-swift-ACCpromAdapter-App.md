---
layout: post
title: "ACCpromAdapter App – Monitoring und Analyse von Apple Content Cache Metriken"
date: 2025-03-02 16:38:03 +0000
categories: Swift Apple macOS Content Cache Prometheus Grafana
tags: Apple macOS
image:
  path: https://images.cstrube.de/blog/images/swift-ACCpromAdapter-App/0001-swift-ACCpromAdapter-App-79b055b2-5fc7-4710-bdbd-b0a008886c4d.webp
  lqip: data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAMCAgMCAgMDAgMDAwMDBAcFBAQEBAkGBwUHCgkLCwoJCgoMDREODAwQDAoKDhQPEBESExMTCw4UFhQSFhESExL/2wBDAQMDAwQEBAgFBQgSDAoMEhISEhISEhISEhISEhISEhISEhISEhISEhISEhISEhISEhISEhISEhISEhISEhISEhL/wAARCAALABQDAREAAhEBAxEB/8QAGAAAAgMAAAAAAAAAAAAAAAAABAgFBgf/xAAkEAACAgIBBAIDAQAAAAAAAAABAgMEBREGABIhMRNhB0Fxkf/EABgBAAMBAQAAAAAAAAAAAAAAAAIDBQQG/8QAJREAAgEDAwQCAwAAAAAAAAAAAQIRAAMhBAVREiIxQRNhgZHR/9oADAMBAAIRAxEAPwBOPx5wObkLyyVo61GukDzRz5KQQRsVGwgZvZbet+h7J6v9pkA1w+6bmmjROsFixAhQTE+/xW2YSHgvC8XUfmmawVbIySuZoVAtiWsyKyNCY9qJQQ66bwdg78ecGpsXHJ6Tj9Z/lDt+8Ev2actH1A4zPGDVI5FyLjOcykl7G1RVqT+YIplX5AmyF7u0a7ta3rp+jsMtkBzJrfqrjm6Sojxgcxmlul5Tl8iCl/I2rIkUBvlk7zofrZ9D66YltFwoir91i4ljPupPFXJqkqSVnMToCqsoAKgjyB/dn/eiGPFTr1tXBDCRRT5O1F2pFYkRFXSqp0AProuo80r4kOSK/9k=
---

Die [**ACCPromAdapter App**](https://github.com/Madchristian/ACCpromAdapter) ist eine innovative macOS-Anwendung, die speziell dafür entwickelt wurde, die Metriken des Apple Content Cache zu überwachen und in einem Prometheus-kompatiblen Format bereitzustellen. Dank ihrer flexiblen Architektur können Administratoren und DevOps-Teams die Caching-Infrastruktur bequem visualisieren – etwa in Grafana. Zusätzlich bieten wir mit dem **ACCPromAdapterDaemon** eine Lösung für headless Installationen an, bei denen der Dienst automatisch beim Systemstart aktiv ist und Metriken auch ohne Benutzeranmeldung sammelt.

## Was ist ACCPromAdapter?

ACCPromAdapter verbindet sich mit dem Apple Content Cache und liest die Metriken aus der zugehörigen **Metrics.db** aus. Die App entscheidet intelligent, ob sie die Metriken von einem extern laufenden Daemon (HTTP-Server) oder über den direkten Zugriff auf die lokale Datenbank bezieht. Diese duale Strategie stellt sicher, dass immer aktuelle Daten zur Verfügung stehen – unabhängig davon, ob der externe Dienst verfügbar ist oder nicht.

## Hauptfunktionen

- **Automatische Umgebungserkennung:** Beim Start prüft die App, ob ein externer HTTP-Daemon aktiv ist, der die Metriken bereits bereitstellt. Falls ja, werden diese genutzt; andernfalls greift die App auf die lokale Metrics.db zu.
- **Prometheus-kompatibler Output:** Die Metriken werden in einem Format ausgegeben, das direkt von Prometheus abgefragt werden kann. So lässt sich die App nahtlos in Grafana-Dashboards integrieren.
- **Benutzerfreundliche Menüleisten-Anzeige:** Ein übersichtliches UI in der macOS-Menüleiste zeigt die wichtigsten Metriken an – ergänzt durch einen visuellen Statusindikator, der den aktiven Modus (extern oder lokal) anzeigt.
- **Automatische Aktualisierung:** Die Metriken werden in regelmäßigen 30-Sekunden-Zyklen aktualisiert, wobei ein Fortschrittsbalken den aktuellen Stand des Updates visuell darstellt.
- **Headless Installation mit [ACCPromAdapterDaemon](https://github.com/Madchristian/ACCpromAdapterDaemon/releases/latest):** Für Umgebungen ohne Benutzeranmeldung, wie z. B. Server oder Headless Mac Minis, bietet der ACCPromAdapterDaemon eine vollständig automatisierte Lösung. Der Daemon startet beim Systemstart und liefert kontinuierlich Metriken, die von Prometheus abgefragt werden können.

---
  ![0002-swift-ACCpromAdapter-App-1e675289-9e76-463b-986e-7dcbe2562a8d.jpg!](https://images.cstrube.de/blog/images/swift-ACCpromAdapter-App/0002-swift-ACCpromAdapter-App-1e675289-9e76-463b-986e-7dcbe2562a8d.webp){: style="max-width:150px; height:auto;" lqip="data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAkACQAAD/2wBDAAICAgICAQICAgIDAgIDAwYEAwMDAwcFBQQGCAcJCAgHCAgJCg0LCQoMCggICw8LDA0ODg8OCQsQERAOEQ0ODg7/2wBDAQIDAwMDAwcEBAcOCQgJDg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg7/wAARCAAdABQDASIAAhEBAxEB/8QAGwAAAQQDAAAAAAAAAAAAAAAAAAIDBAUGBwn/xAArEAABBAEEAQIEBwAAAAAAAAABAgMEEQUABhIhEzFRBxQicRUjQUJhkaL/xAAXAQADAQAAAAAAAAAAAAAAAAABAgME/8QAHxEAAQQCAgMAAAAAAAAAAAAAAQACESEDEhMxkaGx/9oADAMBAAIRAxEAPwDnXjnYDuFivHaGGePi4qUqLMWXDVciUyQL6voAXfWsdzENQzTjyYTOMjuH8tllC0tigLoLWtXr7qPrpeLdjnb0QrLHLhZ5mOFf6QT/AGdIMqG/kI63YsoQwD5BHbbbWr2ohHH19wf401pYChPKbiJYZVEjvK8QWXFpWlSuX1d/XRq6BFdAaNQs0/HTm6iodRH8SPGl0pKwK/cUgC/fr72dGlgoahWGNE53b7HyWL3RIilHELhc1sk9hVcUEH7X76jpl76DXy+DZ3LDgsKLRYbU+4lCgbIpKAEnsWmuvXV3ivi/Mw+2Y2Kh7RwqGGGg2FpfntlagO3CESUp5EkkkJAv9NNYz4w5PF4puKjbmLkvA8n5bsueHpKyKLjhRJSFLNC1UL1sztbjA4zuT3FR5hVwhrydzr7+Std5KVlZOaeXl3pL2QB4vGWVF0EdUrl3Y9jo05uLNHcW65GX/D42HW/RcYglzxlVdrJcWtRUfUkqPejU22JNIOgOIFhf/9k=" }
## Technische Architektur

Die App ist in **Swift** geschrieben und nutzt moderne Technologien wie **Swift Concurrency (async/await)**, **Combine** und **SwiftNIO** für die Netzwerkkommunikation. Dabei wird ein modularer Ansatz verfolgt:
- **AppInitializer:** Verantwortlich für die zentrale Initialisierung der Anwendung und die Entscheidung, ob externe oder lokale Metriken verwendet werden.
- **MetricsCache:** Sammelt und aktualisiert die Metriken aus der lokalen Datenbank, falls kein externer Daemon verfügbar ist.
- **MetricsFetcher:** Holt die Metriken über HTTP, wenn der externe Daemon aktiv ist.
- **PrometheusServer:** Startet einen internen HTTP-Server, der Prometheus-kompatiblen Output liefert – als Fallback, wenn kein externer Dienst vorhanden ist.
- **ACCPromAdapterDaemon:** Ein separater Daemon, der speziell für headless Installationen konzipiert wurde. Er läuft systemweit, sammelt Metriken aus der Metrics.db und stellt sie über einen HTTP-Endpunkt bereit, ohne dass ein Benutzer eingeloggt sein muss.

## Einsatzmöglichkeiten

ACCPromAdapter eignet sich ideal für:
- **Administrator:innen und IT-Teams**, die die Performance und Auslastung ihres Apple Content Cache überwachen möchten.
- **DevOps-Teams**, die Dashboards in Grafana erstellen wollen, um Metriken in Echtzeit zu visualisieren.
- **Headless Umgebungen**, in denen der ACCPromAdapterDaemon dafür sorgt, dass Metriken automatisch auch ohne Benutzeranmeldung gesammelt werden.

## Installation & Erste Schritte

1. **ACCPromAdapter App:** Laden Sie die App direkt bei [Github](https://github.com/Madchristian/ACCpromAdapter/releases/tag/publish) herunter. Beim ersten Start werden Sie aufgefordert, die **Metrics.db** auszuwählen, um den Lesezugriff zu konfigurieren.
2. **ACCPromAdapterDaemon (Optional)**: Laden Sie das Installationspaket (ACCpromAdapterDaemon.pkg) herunter – verfügbar über GitHub oder als Direktdownload im Blog. Installieren Sie den Daemon, der beim Systemstart automatisch aktiviert wird.
3. **Monitoring:** Starten Sie die App und beobachten Sie die Metriken in der Menüleiste. Falls der externe Daemon aktiv ist, werden die Metriken von diesem abgerufen.
4. **Grafana-Integration:** Konfigurieren Sie Prometheus so, dass es die Metriken von `http://localhost:9200/metrics` abruft, und erstellen Sie ein passendes Dashboard in Grafana.

![0002-swift-ACCpromAdapter-App-c62ae52b-fecb-459e-91ca-2e771c9fe4c0.jpg!](https://images.cstrube.de/blog/images/swift-ACCpromAdapter-App/0002-swift-ACCpromAdapter-App-c62ae52b-fecb-459e-91ca-2e771c9fe4c0.webp){: w="600" h="400" lqip="data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAkACQAAD/2wBDAAICAgICAQICAgIDAgIDAwYEAwMDAwcFBQQGCAcJCAgHCAgJCg0LCQoMCggICw8LDA0ODg8OCQsQERAOEQ0ODg7/2wBDAQIDAwMDAwcEBAcOCQgJDg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg4ODg7/wAARCAANABQDASIAAhEBAxEB/8QAFwAAAwEAAAAAAAAAAAAAAAAAAAQHCf/EACIQAAEEAQIHAAAAAAAAAAAAAAEAAgMEEgYRBTEyQVFhcf/EABQBAQAAAAAAAAAAAAAAAAAAAAD/xAAUEQEAAAAAAAAAAAAAAAAAAAAA/9oADAMBAAIRAxEAPwDM7XHCaLHC22LCd1bMnI81KFYdfzRRwVA+J8mUYY4CXEEbb+FHkD9QtFd25AOXc+ghKs6T9Qg//9k=" }

## Fazit

ACCPromAdapter und der [ACCPromAdapterDaemon](https://github.com/Madchristian/ACCpromAdapterDaemon/releases/tag/Version1) bieten zusammen eine flexible und robuste Lösung zur Überwachung der Apple Content Cache Metriken. Mit der dualen Strategie – ob über einen externen HTTP-Daemon oder direkt aus der lokalen Datenbank – garantiert die Lösung stets aktuelle und zuverlässige Daten. Dieses innovative Tool hilft Ihnen, die Performance Ihrer Caching-Infrastruktur optimal zu überwachen und Probleme frühzeitig zu erkennen.

Bleiben Sie dran für weitere Updates und Verbesserungen der ACCPromAdapter App!

---

*Für Fragen und Feedback stehe ich Ihnen jederzeit zur Verfügung – kontaktieren Sie mich über [GitHub](https://github.com/MadChristian) oder per E-Mail.*
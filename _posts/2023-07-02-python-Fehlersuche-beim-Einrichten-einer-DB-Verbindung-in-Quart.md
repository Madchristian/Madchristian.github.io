---
title: Fehlersuche beim Einrichten einer Datenbank-Verbindung in Quart
date: 2023-07-01 23:00:00 +0100
categories: [Programming, Python]
tags: [quart, api, development, flask, database, python, async, await]
image:
  path: https://images.cstrube.de/uploads/original/22/d1/934902b9eddcd04600f3224332e5.webp
  lqip: data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAYEBAQFBAYFBQYJBgUGCQsIBgYICwwKCgsKCgwQDAwMDAwMEAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/2wBDAQcHBw0MDRgQEBgUDg4OFBQODg4OFBEMDAwMDBERDAwMDAwMEQwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/wAARCAAPABQDAREAAhEBAxEB/8QAGAAAAgMAAAAAAAAAAAAAAAAAAgMEBgf/xAArEAABAwMBAw0AAAAAAAAAAAACARESAAMEIQUxUQYTFSIjM0FTYnGCodH/xAAYAQEAAwEAAAAAAAAAAAAAAAACAAMEAf/EACQRAAEDAgQHAAAAAAAAAAAAAAEAAhEDEgQiUWETIUFSkrLi/9oADAMBAAIRAxEAPwDL8jbmZiLbW1klbt3EIU3aKK6u4lxrokkgIVC1oBIm5KLlnti2CAOQpiSusVD76lMMdqqDiGaHy+VK6ay25yfbThL1Si8dz0J5StVuaN1Xci4tyzaHJtmAgpwJ0R3XXfwqCQTCFVrXAXGIlDbDCTzF+QflMOfoqODS7vVFPIk0C76Tv4zePvVfRbJzTuv/2Q==
---
# Fehlersuche beim Einrichten einer Datenbank-Verbindung in Quart

Die Fehlermeldung `KeyError: 'USER_DB_MANAGER'` in einer Quart-Anwendung kann auftreten, wenn versucht wird, auf ein Konfigurationselement zuzugreifen, das noch nicht in die Anwendungskonfiguration aufgenommen wurde. Im folgenden Artikel werden wir die möglichen Ursachen dieses Problems untersuchen und Vorschläge zur Lösung dieses Problems geben.

### Problem

Die Fehlermeldung sieht so aus:

```
KeyError: 'USER_DB_MANAGER'
```

Dieser Fehler weist darauf hin, dass der Schlüssel 'USER_DB_MANAGER' im aktuellen `app`-Konfigurationsobjekt nicht gefunden wird. Dies deutet darauf hin, dass die Initialisierung und Speicherung der Manager in der App-Konfiguration in der Startup-Routine Ihrer Anwendung möglicherweise nicht erfolgreich durchgeführt wurde.

### Lösung

Stellen Sie sicher, dass die Initialisierung der Manager (einschließlich `USER_DB_MANAGER`) und ihre Speicherung in der App-Konfiguration vor den ersten Anfragen erfolgen. Dies geschieht typischerweise in der Setup-Funktion Ihrer App, die bei Start ausgeführt wird. Stellen Sie auch sicher, dass keine Exceptions während dieser Initialisierung ausgelöst werden, die dazu führen könnten, dass der Code zur Speicherung der Manager in der App-Konfiguration nicht erreicht wird.

Ein Beispiel könnte wie folgt aussehen:

```python
@app.before_serving
async def startup():
    """
    This function is called before the app starts.
    It initializes the app container and the database managers.
    """
    # Your code to initialize managers...
    user_db_manager = ...

    # Store managers into the app config for easy access
    app.config['USER_DB_MANAGER'] = user_db_manager
```

Sie können später in Ihrer Route darauf zugreifen:

```python
@user_api_blueprint.before_app_first_request
async def setup():
    user_db_manager = current_app.config['USER_DB_MANAGER']
    # the rest of your code...
```

### Fazit

Bei der Arbeit mit Quart und anderen asynchronen Web-Frameworks ist es wichtig, die Initialisierung von Ressourcen wie Datenbank-Verbindungen sorgfältig zu steuern. Stellen Sie sicher, dass alle erforderlichen Ressourcen korrekt initialisiert und in der Anwendungskonfiguration gespeichert sind, bevor Sie versuchen, sie in Ihren Anforderungshandlern zu verwenden.
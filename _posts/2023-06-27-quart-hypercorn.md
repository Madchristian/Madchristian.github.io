---
Titel: Erstellen einer Webanwendung mit Quart und Hypercorn in Python
Datum: 2023-06-27
Kategorien: [Programming, Python, Quart, Hypercorn]
Tags: [python, quart, hypercorn, webapp, api]
---

# Erstellen einer Webanwendung mit Quart und Hypercorn in Python

Im heutigen Blogpost möchten wir uns auf das Erstellen von Webanwendungen mit Quart und Hypercorn in Python konzentrieren. Quart ist ein leistungsfähiges, asynchrones Web-Framework für Python, während Hypercorn ein ASGI-Server ist, der dazu dient, Ihre Quart-Anwendung zu hosten.

Die Quart-Anwendung, die wir in diesem Beitrag erstellen, integriert mehrere Technologien und Konzepte, darunter Redis, RabbitMQ und PostgreSQL. Dieser Beitrag geht davon aus, dass Sie mit Python und Grundlagen der Webentwicklung vertraut sind.

## Die Hauptanwendung erstellen

Zuerst importieren wir die benötigten Module. Quart ist das Hauptmodul, das wir verwenden werden, um unsere Webanwendung zu erstellen. Wir importieren auch mehrere Blueprints, die unsere Anwendungsrouten definieren:

```python
# quartapp.py
import asyncio
from quart import Quart 
from hypercorn.asyncio import serve 
from hypercorn.config import Config 
from quart_redis import RedisHandler 

from app.common.config import Config
from app.common.appcontainer import AppContainer
from app.quart.routes import (metrics_api_blueprint,
                              data_api_blueprint,
                              rabbitmq_api_blueprint,
                              cors_blueprint,
                              user_api_blueprint,
                              group_api_blueprint,
                              audit_trail_api_blueprint)
```

In diesem Codeblock sehen Sie, dass wir verschiedene Blueprints importieren, die die verschiedenen Teile unserer Anwendung definieren. Ein Blueprint in Quart ist ein Modul, das mehrere Routen, Vorlagen und statische Dateien gruppiert. Mit Blueprints können Sie Ihre Anwendung in logische Abschnitte unterteilen, die getrennt voneinander entwickelt und getestet werden können.

## Registrieren von Blueprints

Mit der `register_blueprint`-Methode von Quart registrieren wir jeden Blueprint:

```python
for bp in blueprints:
    app.register_blueprint(bp['blueprint'])
```

## Verbindung zur Datenbank

Wir erstellen eine Hilfsfunktion, um die Verbindung zur Datenbank herzustellen. Diese Funktion versucht mehrmals, eine Verbindung herzustellen und wartet zwischen den Versuchen, um dem Datenbankserver Zeit zu geben, verfügbar zu werden:

```python
async def connect_with_retry(connect_func, db_name, max_attempts=6, retry_interval=10):
    """
    Try to connect to a database with a given connect_func."""
    for attempt in range(max_attempts):
        try:
            await connect_func()
            logger.info("Connected successfully to %s !", db_name)
            return
        except Exception as e:
            logger.info("Retrying in %s seconds... (%s/%s)", retry_interval, attempt+1, max_attempts)
            await asyncio.sleep(retry_interval)
    logger.error("Max retry attempts reached. Could not connect to %s .", db_name)
    raise SystemExit(f"Could not connect to {db_name}.")
```

## Starten und Beenden der Anwendung

Wir definieren `startup` und `cleanup` Funktionen, die Quart vor bzw. nach dem Start der Anwendung aufruft. In der `startup` Funktion verbinden wir uns mit den Daten

banken und initialisieren die Managerklassen, während wir in der `cleanup` Funktion die Verbindungen und Ressourcen aufräumen:

```python
@app.before_serving
async def startup():
    ...

@app.after_serving
async def cleanup():
    ...
```

## Die Anwendung starten

Schließlich erstellen wir die `main`-Funktion, um die Anwendung zu starten:

```python
if __name__ == "__main__":
    quart_config = create_quart_config()
    config = Config()
    config.bind = [f"{quart_config.host}:{quart_config.port}"]
    config.certfile = quart_config.certfile
    config.keyfile = quart_config.keyfile
    config.protocol = quart_config.protocol
    config.application_path = "quartapp:app"

    asyncio.run(serve(app, config))
```

Dieser Code startet den Hypercorn-Server und bindet ihn an die von der Konfiguration angegebene Adresse und den Port. Danach serviert Hypercorn die Quart-Anwendung und wartet auf eingehende Anfragen.

Das ist alles! Mit diesen wenigen Schritten haben wir eine grundlegende Quart-Anwendung erstellt und mit Hypercorn gehostet. In zukünftigen Blogposts werden wir uns eingehender mit den einzelnen Aspekten dieser Anwendung befassen und uns ansehen, wie wir diese Anwendung weiter anpassen und erweitern können.

---

Schlüsselwörter: #Quart #Hypercorn #WebApp #Python #ASGI #APIs #WebEntwicklung
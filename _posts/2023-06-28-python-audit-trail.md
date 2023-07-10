---
title: "Building an Audit Trail with Quart, MongoDB, and Redis"
date: 2023-06-28 14:00:00 +0100
categories: [Programming, Python]
tags: ["auditTrail", "webDevelopment", "backend", "microservices"]
image: 
    path: https://images.cstrube.de/uploads/original/77/28/363f54392a114a7b929b4a21ad6c.webp
    lqip: data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAYEBAQFBAYFBQYJBgUGCQsIBgYICwwKCgsKCgwQDAwMDAwMEAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/2wBDAQcHBw0MDRgQEBgUDg4OFBQODg4OFBEMDAwMDBERDAwMDAwMEQwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/wAARCAAPABQDAREAAhEBAxEB/8QAGAAAAgMAAAAAAAAAAAAAAAAAAgMEBgf/xAArEAABAwMBAw0AAAAAAAAAAAACARESAAMEIQUxUQYTFSIjM0FTYnGCodH/xAAYAQEAAwEAAAAAAAAAAAAAAAACAAMEAf/EACQRAAEDAgQHAAAAAAAAAAAAAAEAAhEDEgQiUWETIUFSkrLi/9oADAMBAAIRAxEAPwDL8jbmZiLbW1klbt3EIU3aKK6u4lxrokkgIVC1oBIm5KLlnti2CAOQpiSusVD76lMMdqqDiGaHy+VK6ay25yfbThL1Si8dz0J5StVuaN1Xci4tyzaHJtmAgpwJ0R3XXfwqCQTCFVrXAXGIlDbDCTzF+QflMOfoqODS7vVFPIk0C76Tv4zePvVfRbJzTuv/2Q==
---

# Building an Audit Trail with Quart, MongoDB, and Redis

In this post, we will explore how to build an Audit Trail system using Quart for Python, MongoDB, and Redis. This will involve implementing MongoDB for data storage, Quart for the web server and API, and Redis for caching data. We will create several API routes for managing audit entries in a MongoDB database.

## Introduction to the Modules

Our code is organized in several modules. Each module is responsible for handling specific aspects of the audit trail system. 

### The `AuditTrailDBManager` Class 

The `AuditTrailDBManager` is defined in `app/common/managers/audittraildbmanager.py`. This class is responsible for managing the operations of the `AuditTrailDB`, which is a MongoDB database that we use for storing our audit trail entries. It provides methods for connecting to the MongoDB server, inserting documents, finding documents based on a query, updating documents, deleting documents, and saving and loading model data.

```python
class AuditTrailDBManager(IMongoDB, IDependency):
    """
    AuditTrailDBManager is a class for managing the AuditTrailDB operations."""
    ...
```

The `AuditTrailDBManager` uses the `motor` library for making asynchronous MongoDB operations.

### The Quart API Routes

We have defined our API routes in `app/quart/routes/mongo_api_routes.py`. We use the Quart library for Python to create these routes. Quart allows us to create API routes in a manner similar to Flask, but with support for Python's `asyncio` library for asynchronous operations.

Our API has several routes:

- `/apiv3/audit_trail/check-port`: Checks if the API is running.
- `/apiv3/audit_trail/entries`: Supports the `POST` method for creating a new audit entry and the `GET` method for retrieving audit entries.
- `/apiv3/audit_trail/entries/<entry_id>`: Supports the `PUT` method for updating an audit entry with a given ID, and the `DELETE` method for deleting an audit entry with a given ID.

Here is a code snippet for one of the routes:

```python
@audit_trail_api_blueprint.route('/entries', methods=['POST'])
@verify_jwt_token
async def create_audit_entry():
    """
    Erstellt einen neuen Audit-Eintrag."""
    ...
```

Each route function uses the `@verify_jwt_token` decorator, which verifies the JWT token for user authentication.

The API routes interact with the MongoDB database through the `AuditTrailDataController`.

### The `AuditTrailDataController` Class

The `AuditTrailDataController` is responsible for controlling the data of the audit trail. It uses the `AuditTrailDBManager` to interact with the MongoDB database.

The `AuditTrailDataController` is initialized before the first request to the Quart application is made:

```python
@audit_trail_api_blueprint.before_app_first_request
async def init_audit_trail_data_controller():
    """
    Initialisiert den AuditTrailDataController"""
    ...
```

## Redis for Caching

To reduce the load on the MongoDB server and speed up our application, we use Redis for caching the results of the `GET` requests. We store the results of each unique query in Redis. The next time the same query is made, we return the cached results from Redis instead of querying the MongoDB database again.

Here is a code snippet for the

 `GET` request route that uses Redis:

```python
@audit_trail_api_blueprint.route('/entries', methods=['GET'])
@verify_jwt_token
async def get_audit_entries():
    ...
    # Erhalte Redis-Instanz
    redis = await get_redis()

    # Konvertiere query dict in str für den Gebrauch mit Redis
    query_str = json.dumps(query, sort_keys=True)
    cached_entries = await redis.get(query_str)

    if cached_entries is not None:
        ...
    else:
        entries = await audittrail_data_controller.get_audit_entries(query)
        ...
```

In this code snippet, we get the Redis instance and then convert the query dictionary into a string to use with Redis. If the query results are already cached in Redis, we return those results. Otherwise, we get the audit entries from MongoDB and store the results in Redis for future requests.

## Conclusion

We have discussed how to build an audit trail system using Quart for Python, MongoDB, and Redis. The system provides API routes for managing audit entries stored in a MongoDB database and uses Redis for caching query results. The `AuditTrailDBManager` class manages the MongoDB operations, and the `AuditTrailDataController` controls the audit trail data. This system is a good example of how to use Quart, MongoDB, and Redis together to create a highly efficient and scalable web application.

In future posts, we'll further dive into the usage of Quart and other technologies to build highly scalable microservices. Stay tuned!

---
---
# Aufbau eines Audit-Trail mit Quart, MongoDB und Redis

In diesem Beitrag werden wir untersuchen, wie man ein Audit Trail System mit Quart für Python, MongoDB und Redis erstellt. Dabei implementieren wir MongoDB für die Datenspeicherung, Quart für den Webserver und die API sowie Redis zur Zwischenspeicherung von Daten. Wir werden mehrere API-Routen erstellen, um Audit-Einträge in einer MongoDB-Datenbank zu verwalten.

### Einführung in die Module

Unser Code ist in mehrere Module organisiert. Jedes Modul ist für bestimmte Aspekte des Audit Trail Systems zuständig.

---
## Die Klasse "AuditTrailDBManager"

Der "AuditTrailDBManager" ist in "app/common/managers/audittraildbmanager.py" definiert. Diese Klasse ist für die Verwaltung der Operationen der "AuditTrailDB" zuständig, einer MongoDB-Datenbank, in der wir unsere Audit Trail Einträge speichern. Sie bietet Methoden zum Verbinden mit dem MongoDB-Server, zum Einfügen von Dokumenten, zum Suchen von Dokumenten basierend auf einer Abfrage, zum Aktualisieren von Dokumenten, zum Löschen von Dokumenten sowie zum Speichern und Laden von Modelldaten.

```python
class AuditTrailDBManager(IMongoDB, IDependency):
    """
    AuditTrailDBManager ist eine Klasse zur Verwaltung der AuditTrailDB-Operationen."""
    ...
```

Der "AuditTrailDBManager" verwendet die Motor-Bibliothek für asynchrone MongoDB-Operationen.

---
## Die Quart-API-Routen

Wir haben unsere API-Routen in "app/quart/routes/mongo_api_routes.py" definiert. Wir verwenden die Quart-Bibliothek für Python, um diese Routen zu erstellen. Quart ermöglicht es uns, API-Routen ähnlich wie Flask zu erstellen, unterstützt jedoch die asynchrone Funktionalität von Pythons asyncio-Bibliothek.

### Unsere API hat mehrere Routen:

- `/apiv3/audit_trail/check-port`: Überprüft, ob die API läuft.
- `/apiv3/audit_trail/entries`: Unterstützt die POST-Methode zum Erstellen eines neuen Audit-Eintrags und die GET-Methode zum Abrufen von Audit-Einträgen.
- `/apiv3/audit_trail/entries/<entry_id>`: Unterstützt die PUT-Methode zum Aktualisieren eines Audit-Eintrags mit einer bestimmten ID und die DELETE-Methode zum Löschen eines Audit-Eintrags mit einer bestimmten ID.

Hier ist ein Code-Schnipsel für eine der Routen:

```python
@audit_trail_api_blueprint.route('/entries', methods=['POST'])
@verify_jwt_token
async def create_audit_entry():
    """
    Erstellt einen neuen Audit-Eintrag."""
    ...
```

Jede Routenfunktion verwendet den Dekorator "@verify_jwt_token", der das JWT-Token für die Benutzerauthentifizierung überprüft.

Die API-Routen interagieren über den "AuditTrailDataController" mit der MongoDB-Datenbank.

---
## Die Klasse "AuditTrailDataController"
Der "AuditTrailDataController" ist für die Steuerung der Daten des Audit Trails zuständig. Er verwendet den "AuditTrailDBManager", um mit der MongoDB-Datenbank zu interagieren.

Der "AuditTrailDataController" wird initialisiert, bevor die erste Anfrage an die Quart-Anwendung gestellt wird:

```python
@

audit_trail_api_blueprint.before_app_first_request
async def init_audit_trail_data_controller():
    """
    Initialisiert den AuditTrailDataController."""
    ...
```
---
## Redis zur Zwischenspeicherung

Um die Belastung des MongoDB-Servers zu reduzieren und unsere Anwendung zu beschleunigen, verwenden wir Redis zur Zwischenspeicherung der Ergebnisse der GET-Anfragen. Wir speichern die Ergebnisse jeder eindeutigen Abfrage in Redis. Beim nächsten Mal, wenn dieselbe Abfrage gestellt wird, geben wir die zwischengespeicherten Ergebnisse aus Redis zurück, anstatt die MongoDB-Datenbank erneut abzufragen.

Hier ist ein Code-Schnipsel für die GET-Anfrage-Route, die Redis verwendet:

```python
@audit_trail_api_blueprint.route('/entries', methods=['GET'])
@verify_jwt_token
async def get_audit_entries():
    ...
    # Hole Redis-Instanz
    redis = await get_redis()

    # Konvertiere query dict in str für die Verwendung mit Redis
    query_str = json.dumps(query, sort_keys=True)
    cached_entries = await redis.get(query_str)

    if cached_entries is not None:
        ...
    else:
        entries = await audittrail_data_controller.get_audit_entries(query)
        ...
```

In diesem Code-Schnipsel holen wir die Redis-Instanz und konvertieren dann das Abfrage-Dictionary in einen String, um es mit Redis zu verwenden. Wenn die Abfrageergebnisse bereits in Redis zwischengespeichert sind, geben wir diese Ergebnisse zurück. Andernfalls holen wir die Audit-Einträge aus MongoDB und speichern die Ergebnisse in Redis für zukünftige Anfragen.

Fazit

Wir haben besprochen, wie man ein Audit Trail System mit Quart für Python, MongoDB und Redis erstellt. Das System bietet API-Routen zur Verwaltung von Audit-Einträgen, die in einer MongoDB-Datenbank gespeichert sind, und verwendet Redis zur Zwischenspeicherung von Abfrageergebnissen. Die Klasse "AuditTrailDBManager" verwaltet die MongoDB-Operationen und der "AuditTrailDataController" steuert die Audit Trail Daten. Dieses System ist ein gutes Beispiel dafür, wie man Quart, MongoDB und Redis zusammen verwendet, um eine hoch effiziente und skalierbare Webanwendung zu erstellen.

In zukünftigen Beiträgen werden wir noch weiter auf den Einsatz von Quart und anderen Technologien zur Entwicklung hoch skalierbarer Microservices eingehen. Bleiben Sie dran!
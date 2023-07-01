---
title: "Building an Audit Trail with Quart, MongoDB, and Redis"
date: 2023-06-28 14:00:00 +0100
categories: ["Quart", "MongoDB", "Redis", "Python", "APIs"]
tags: ["Audit Trail", "Web Development", "Backend", "Microservices", "Python"]
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
---
layout: post
title: "Apple Push Notification Service mit Quart und Python: Ein Leitfaden"
date: 2023-07-21 22:47:44 +0000
categories: ['Programming', 'iOS']
tags: swift python apns
image:
  path: https://images.cstrube.de/blog/images/swift-apns/swift-apns.webp
  lqip: data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAIBAQIBAQICAgICAgICAwUDAwMDAwYEBAMFBwYHBwcGBwcICQsJCAgKCAcHCg0KCgsMDAwMBwkODw0MDgsMDAz/2wBDAQICAgMDAwYDAwYMCAcIDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/wAARCAAPABQDAREAAhEBAxEB/8QAGAAAAgMAAAAAAAAAAAAAAAAAAwUGBwj/xAAmEAABAwMDBAIDAAAAAAAAAAABAgMEBRESAAYhBxMxUQgUIiOB/8QAFwEAAwEAAAAAAAAAAAAAAAAAAQIDBP/EACURAAICAQIFBQEAAAAAAAAAAAECAxEAMdEEEiFBQhNygaHhkf/aAAwDAQACEQMRAD8AwM71hG3ZTqJe4Z8BDyG32GGqd9hKkm/BcC0lNrelaRbdmJciiR0rbLSBY1QLGrWoNm98FP8Akhu1xhKaDNqsuH2u5KMmBj21Ak3yHGNgVAnxyObaYpJ4yN9bZISReUS/e+PNvdYqnUdvw5NQmKVIkN53SAkWyIFh/NVhckGzfXBxMagqVFWO2Us11CpSaxTZkh99uTT2G28TELiMk5WVdLiT5IItbkDWcLMjEqt9SdazRIYHVQ7kUANL0+ckrXWWjyD3nZU92WofskGEn8jckWGdwBfwVHnnVQ851Qf38yPocN2kNe39xLVN7NTiwqNIkPoS3YuOtBtS1FSiTYE+/ejGCL5tbwzsh5QhsAVn/9k=
---
Echtzeitbenachrichtigungen sind ein wesentlicher Bestandteil moderner Anwendungen, um die Benutzererfahrung zu verbessern und die Benutzerbindung zu erhöhen. In diesem Blogbeitrag werde ich erklären, wie man den Apple Push Notification Service (APNs) mit Quart, einem asynchronen Python-Web-Framework, einrichtet und verwendet.

## Voraussetzungen
Bevor wir beginnen, stellen Sie sicher, dass Sie Folgendes haben:
- Ein APNs-Zertifikat, das von Apple ausgestellt wurde.
- Die Bundle-ID Ihrer App.
- Die Gerätekennung für jedes Gerät, das Benachrichtigungen empfangen soll.

## Quart-Setup
Zunächst einmal installieren wir Quart und aioapns, eine asynchrone APNs-Bibliothek für Python, indem wir den folgenden Befehl ausführen:

```bash
pip install quart aioapns
```

Jetzt, da wir Quart und aioapns installiert haben, können wir beginnen, unseren Code zu schreiben. Zunächst einmal erstellen wir eine neue Quart-App und definieren einige Konfigurationsvariablen.

```python
from quart import Quart, request, jsonify, make_response
from aioapns import APNs, Client, NotificationRequest, PushType

app = Quart(__name__)

# Setzen Sie die Konfigurationsvariablen
app.config['APNS_KEY_FILE'] = '/path/to/your/key.pem' # Pfad zur Schlüsseldatei
app.config['APNS_CERT_FILE'] = '/path/to/your/cert.pem' # Pfad zur Zertifikatsdatei
app.config['APNS_TOPIC'] = 'com.yourcompany.yourapp' # Die Bundle-ID Ihrer App
```

## Einrichten des APNs-Clients
Nun, da wir unsere App konfiguriert haben, können wir den APNs-Client einrichten.

```python
@app.before_serving
async def setup_apns_client():
    client = APNs(
        client_cert=app.config['APNS_CERT_FILE'],
        client_key=app.config['APNS_KEY_FILE'],
        use_sandbox=False, # Setzen Sie dies auf True, wenn Sie den Sandbox-APNs-Server verwenden
    )
    app.config['APNS_CLIENT'] = client
```

## API-Route zum Aktualisieren der Device-Token
Wir werden eine API-Route erstellen, die es Clients erlaubt, ihre Device-Token zu aktualisieren.

```python
@app.route('/update-device-token', methods=['POST'])
async def update_device_token():
    data = await request.get_json()
    device_token = data.get('device_token')

    # Hier würden Sie normalerweise den Token in Ihrer Datenbank speichern.
    # Zum Zwecke dieses Tutorials drucken wir ihn einfach aus.
    print(f"Received device token: {device_token}")

    return make_response(jsonify({'message': 'Device token updated successfully'}), 200)
```

## Senden von Push-Benachrichtigungen
Jetzt können wir eine Funktion erstellen, um Push-Benachrichtigungen zu senden.

```python
async def send_push_notification(device_token, message):
    client = app.config['APNS_CLIENT']
    notification_request = NotificationRequest(
        device_token=device_token,
        message={
            "aps": {
                "alert": message,
                "badge": 1,
            }
        },
        push_type=PushType.ALERT,
    )
    try {
        response = await client.send_notification(notification_request)
        if response.is_successful:
            print(f"Notification sent successfully to {device_token}")
        else:
            print(f"Failed to send notification: {response.error_reason}")
    } except Exception as e {
        print(f"An error occurred while sending the notification: {str(e)}")
    }
```

Jetzt können Sie die `send_push_notification`-Funktion verwenden, um eine Push-Benachrichtigung an ein bestimmtes Gerät zu senden. Geben Sie einfach den Gerätetoken und die Nachricht, die Sie senden möchten, als Argumente an.

Und das war's! Sie haben jetzt einen lauffähigen Quart-Server, der Push-Benachrichtigungen über den Apple Push Notification Service senden kann. Beachten Sie, dass dieser Code nur für Demonstration und Bildungszwecke gedacht ist und Sie ihn entsprechend Ihren Anforderungen anpassen und erweitern sollten, insbesondere im Hinblick auf Fehlerbehandlung und Sicherheit.
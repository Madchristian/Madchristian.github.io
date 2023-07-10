---
title: "Erstellen von Einladungslinks zur Benutzerauthentifizierung in einer mobilen App"
date: 2023-07-07 06:45:00 +0100
categories: ['iOS Development', 'Swift', 'Pyhton']
tags: ['asynchronous programming', 'networking', 'token']
author: "Christian Strube"
image:
    path: https://images.cstrube.de/uploads/original/b1/dc/e5379756d9edc2b88b1b9dd6155d.webp
    lqip: data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAYEBAQFBAYFBQYJBgUGCQsIBgYICwwKCgsKCgwQDAwMDAwMEAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/2wBDAQcHBw0MDRgQEBgUDg4OFBQODg4OFBEMDAwMDBERDAwMDAwMEQwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/wAARCAAPABQDAREAAhEBAxEB/8QAGAAAAgMAAAAAAAAAAAAAAAAAAgMEBgf/xAArEAABAwMBAw0AAAAAAAAAAAACARESAAMEIQUxUQYTFSIjM0FTYnGCodH/xAAYAQEAAwEAAAAAAAAAAAAAAAACAAMEAf/EACQRAAEDAgQHAAAAAAAAAAAAAAEAAhEDEgQiUWETIUFSkrLi/9oADAMBAAIRAxEAPwDL8jbmZiLbW1klbt3EIU3aKK6u4lxrokkgIVC1oBIm5KLlnti2CAOQpiSusVD76lMMdqqDiGaHy+VK6ay25yfbThL1Si8dz0J5StVuaN1Xci4tyzaHJtmAgpwJ0R3XXfwqCQTCFVrXAXGIlDbDCTzF+QflMOfoqODS7vVFPIk0C76Tv4zePvVfRbJzTuv/2Q==
---
In diesem Tutorial gehen wir durch den Prozess der Erstellung von Einladungslinks, die es Benutzern ermöglichen, sich in Ihrer App zu authentifizieren und bestimmten Benutzergruppen beizutreten.

## **Vorbereitung**
1. Sie benötigen eine mobile App, die mit Apple SignIn integriert ist.
2. Ein Backend-Server, der in der Lage ist, JWT (JSON Web Token) zu generieren und zu validieren. In diesem Tutorial verwenden wir Quart, ein Python-Web-Framework.
3. Ihre App muss eine Web-Domain haben, die Apple verifizieren kann (z.B. `https://api0.example.com`), und Sie müssen in der Lage sein, die `apple-app-site-association` (AASA) Datei dort bereitzustellen.

## **Schritt 1: Erstellen der Einladungslink-Route auf dem Backend-Server**
Die erste Aufgabe besteht darin, eine neue Route auf dem Backend-Server zu erstellen, die `/get-invite-link` genannt werden könnte. Diese Route generiert ein JWT, das Informationen über die Gruppen-ID enthält, zu der der Benutzer eingeladen wird, und sendet dieses Token zurück an die mobile App.

```python
@app.route('/get-invite-link', methods=['POST'])
async def get_invite_link():
    data = await request.get_json()
    group_id = data.get('group_id')

    if not group_id:
        return await make_response(jsonify({'error': 'Missing group_id'}), 400)

    # Create JWT payload
    payload = {
        'group_id': group_id,
        'exp': datetime.utcnow() + timedelta(hours=8)  # 8 hours of validity
    }

    invite_token = jwt.encode(payload, JWT_SECRET, algorithm='HS256')

    # For the simplicity, let's assume your app's URL is https://app.example.com
    invite_link = f"https://app.example.com/invite/{invite_token}"

    return await make_response(jsonify({'invite_link': invite_link}), 200)
```
> **Hinweis:** In diesem Beispiel verwenden wir Quart, ein Python-Web-Framework, um die Route zu erstellen. Wenn Sie ein anderes Framework verwenden, müssen Sie die entsprechenden Methoden verwenden, um die Anfrage zu erhalten und die Antwort zu senden.
{: .prompt-info }

## **Schritt 2: Erstellen des Einladungslinks in der mobilen App**
In der mobilen App erstellen Sie einen "Einladungslink erstellen" -Button, der eine Anfrage an die `/get-invite-link`-Route des Backend-Servers sendet und die Gruppen-ID übergibt. Der Server wird ein JWT generieren und zurück an die App senden. Die App wird dann die URL des Einladungslinks erstellen, indem sie das Token an die Basis-URL der App anhängt.

## **Schritt 3: Teilen des Einladungslinks**
In der App können Sie nun den Einladungslink über den gewünschten Kommunikationskanal teilen (z.B. E-Mail, Messaging-Apps, etc.).

## **Schritt 4: Verwenden des Einladungslinks**
Wenn der eingeladene Benutzer auf den Einladungslink klickt, wird die App geöffnet und die App sendet eine Anfrage an eine andere Route auf dem Server, z.B. `/use-invite-link`, und übergibt das Einladungs-Token. Der Server wird das Token validieren, die Benutzer-ID extrahieren und den Benutzer zur entsprechenden Gruppe hinzufügen.

```python

@app.route('/use-invite-link', methods=['POST'])
async def use_invite_link():
    data = await request.get_json()
    user_id = data.get('user_id')
    invite_token = data.get('invite_token')

    if not user_id or not invite_token:
        return await make_response(jsonify({'error': 'Missing user_id or invite_token'}), 400)

    try:
        payload = jwt.decode(invite_token, JWT_SECRET, algorithms=['HS256'])
    except jwt.ExpiredSignatureError:
        return await make_response(jsonify({'error': 'Invite token expired'}), 400)
    except jwt.InvalidTokenError:
        return await make_response(jsonify({'error': 'Invalid invite token'}), 400)

    group_id = payload.get('group_id')

    # Let's assume user_db_manager has a method to add user to a group
    user_db_manager = current_app.config['USERDB_MANAGER']
    await user_db_manager.add_user_to_group(user_id, group_id)

    return await make_response(json
```
Durch die Verwendung von JWT und Apple SignIn können Sie sicherstellen, dass nur authentifizierte Benutzer eingeladen werden und beitreten können. Beachten Sie, dass das Token eine begrenzte Gültigkeitsdauer hat (in unserem Beispiel 8 Stunden), um die Sicherheit zu erhöhen.

---
Dieses Tutorial zeigt, wie Sie Einladungslinks in Ihrer App implementieren können, um Benutzern den Beitritt zu bestimmten Benutzergruppen zu ermöglichen. Mit einigen Anpassungen können Sie es auf die spezifischen Anforderungen Ihrer App abstimmen. Viel Spaß beim Programmieren!
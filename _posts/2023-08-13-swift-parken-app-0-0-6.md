---
layout: post
title: "Parken App Updates 0.0.6: Editiermodus, Zahlenschloss und Historienansicht"
date: 2023-08-13 21:12:53 +0200
categories: swuft app
tags: swiftui iOS app backend
image:
  path: https://images.cstrube.de/blog/images/swiftparkenappv006/parkenm006.webp
  lqip: data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAIBAQIBAQICAgICAgICAwUDAwMDAwYEBAMFBwYHBwcGBwcICQsJCAgKCAcHCg0KCgsMDAwMBwkODw0MDgsMDAz/2wBDAQICAgMDAwYDAwYMCAcIDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/wAARCAAPABQDAREAAhEBAxEB/8QAGAAAAgMAAAAAAAAAAAAAAAAAAAUEBwj/xAAlEAABAwIFBQEBAAAAAAAAAAABAgMEBREABhIhMQcTFEFRCCL/xAAXAQEBAQEAAAAAAAAAAAAAAAADAgQB/8QAJxEAAgEDAQYHAAAAAAAAAAAAAQIRAAMSIQQiMYHR4TJBUVOCkaH/2gAMAwEAAhEDEQA/AMDyurqcudzyMyzKeZAS8xGapnk/yRzr1ptvcAG/GIXJyxNwrBI0jpS3AtsIBaVpUGTPnzoqn6aqSKctuh5oqk51xYUI0ikBAKbk2K0rJKgdPq25+Yoq0bt1j9dKMOk71lf3rTih9XarJokR6pynBLdQVKBSEaRqIAtyOPeFssxBkzrU7SiAqVESJ0qjKjnGk1R+EuVKlR34sdtogQ0vJukk33WL88EYzYXlJxWZJPGtbNYYLm5EADhPDnT13qdTZbC22qpUYLSyFrMaEUFSgACbB4AXtuAPZwue0EeCOfahFnZfcJ+PeolQzmzJTHESRKfaba09x5vQtR1KJ2ur79xVsETlpXL7IcQhkAR6V//Z
---
---

## Parken App Updates 0.0.6: Editiermodus, Zahlenschloss und Historienansicht

Hallo liebe Parken-App-Nutzer! Ich freue mich, euch in diesem Beitrag einige aufregende neue Funktionen in der neuesten Version 0.0.6 der Parken App vorstellen zu dürfen. Diese Verbesserungen machen die App nicht nur benutzerfreundlicher, sondern auch sicherer und informativer.

### Editiermodus

Eine der bemerkenswertesten Neuerungen ist der Editiermodus. Es ermöglicht dem Benutzer, bestimmte Fahrzeugdetails wie das Kennzeichen, die FIN/VIN oder den Status des Fahrzeugs zu ändern. 

Um den Editiermodus zu aktivieren, tippen Sie einfach auf einen der Einträge, und Sie werden in den Bearbeitungsmodus versetzt, in dem Sie die gewünschten Änderungen vornehmen können.

```swift
.onTapGesture(count: 1) {
	self.editMode = true
}
```

Ein langer Druck auf den Bildschirm speichert die Änderungen und beendet den Editiermodus:

```swift
.onLongPressGesture {
	if self.editMode {
		saveChanges()
	}
}
```

### Zahlenschloss für den Schlüssel

Eine der interessantesten Neuerungen ist die Einführung eines Zahlenschlosses für den Schlüssel. Diese Funktion ermöglicht es dem Benutzer, über ein einfaches Picker-Interface eine vierstellige Nummer für den Schlüssel festzulegen:

![1!](https://images.cstrube.de/blog/images/swiftparkenappv006/1.webp){: w="800" h="600" lqip="data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAIBAQIBAQICAgICAgICAwUDAwMDAwYEBAMFBwYHBwcGBwcICQsJCAgKCAcHCg0KCgsMDAwMBwkODw0MDgsMDAz/2wBDAQICAgMDAwYDAwYMCAcIDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/wAARCAArABQDAREAAhEBAxEB/8QAHAABAAEEAwAAAAAAAAAAAAAABAIAAwUGBwgJ/8QALBAAAgIBAgUCBgIDAAAAAAAAAQIDBBEFEgAGBxMhMUEICiJRYaEVFiQykf/EABgBAQADAQAAAAAAAAAAAAAAAAABAgQD/8QAIxEAAgIBAwMFAAAAAAAAAAAAAAECEQMSITFRYbEiQYGiwf/aAAwDAQACEQMRAD8A0/U/lyenWm2P4CDoz8XmvCg8m7Uo9a5ZoR2WRzH3ADXeRUkA7iR7n2qwB8+sJTfMa+Q69iM/y2vTysIpIOh3xeSsxjYK/NnLq4BTe+f8NhlT9IB/2b7DybaXuVt9BelfLH8m9ZjY1O9yX8T3TmarItEafbTlu+bSpGmLKvXWugVt23BQsWjZix3eLKDasmz38scoT6jeispNHHCYUwoksI24D1ISUIR+Nvn3PBNavVwJXWwjTNBs0rofvUpEY4cHvOdufbdIQD49ccasufFONU/qvEUZ4YskXd+f1lcwRoLi7VUAoD4H5PGeD2NJL+vVL7V7Mta20wjTylh1Xx6fSHA/XHOXIEpWh7oAjl3q4bG4Z8Mzff7seIADVEEDwxBJEWKJUAY5OB4+546w4BfrNUWZZmvWlZoViMQlbtrj3C+gP54q4SsGNp8vVKvMLX/5a+25mbtGxIUGfx6cRol0AzWbUViwhjcuqoFyc59+OsItIAC6DP1kgZ8iNyP+44vq7AHo/M2mcwhzp+o1LwjxvNd+7tz6Z25x6cNXYDlMbZzLGhHs4ZT+xxDmlyCPWZl5X6Y63qVCKvBdq1zJFJ2Uba2R5wQQfX3HGe2Dhr4bOqOtc89UIdO1SxVs0nryuYxSgjyVAwcqgP74WwdjotIqwKQlaBQTnxGOIB//2Q==" }

```swift
if title == "Schlüssel Nr.:" {
	HStack {
		digitPicker(binding: $firstDigit)
		digitPicker(binding: $secondDigit)
		digitPicker(binding: $thirdDigit)
		digitPicker(binding: $fourthDigit)
	}
}
```

### Historienansicht

Die Parken App bietet jetzt eine Historienansicht, die eine Liste der verschiedenen Statusänderungen für das Fahrzeug anzeigt. Dies ist besonders nützlich, um einen Überblick über die verschiedenen Aktivitäten und Änderungen zu erhalten, die im Laufe der Zeit am Fahrzeug vorgenommen wurden.

![2!](https://images.cstrube.de/blog/images/swiftparkenappv006/2.webp){: w="800" h="600" lqip="data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAIBAQIBAQICAgICAgICAwUDAwMDAwYEBAMFBwYHBwcGBwcICQsJCAgKCAcHCg0KCgsMDAwMBwkODw0MDgsMDAz/2wBDAQICAgMDAwYDAwYMCAcIDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/wAARCAArABQDAREAAhEBAxEB/8QAGwAAAQQDAAAAAAAAAAAAAAAABgQFBwgBAwn/xAAyEAACAQMCBAQEBAcAAAAAAAABAgMEBREGEgAHITEICSJBExUycSNRYZEUJUJSU4HB/8QAGQEAAwEBAQAAAAAAAAAAAAAAAQIDBAAF/8QAJxEAAgIBAgQGAwAAAAAAAAAAAQIAEQMSIQQiMcETQVFhcYEyofD/2gAMAwEAAhEDEQA/AKz3jy2/CXZ7hNpqKyeJq+SWmtqqGe4R3iw0KTVNPI8UgwaN5E3BGkWIu+FI+5mHN0RX32hNVYiNvLl8IEdSUprJ4kJ54DG0qPq+xr8HMJmbf/L2AIAwFP1nIGPdiwAJ9It9I8cs/Kb8L/ivt9wv1vu/PrR0dqq/k8lHItiuAmeKGJvjLJBFToAVkUEFCxZGYsS3SirYu4pyAGpu8ZniIp9J+ILXFoqvmdximutdUimM8lO8UhlkVYlIb4bbV2sPQPSQGY4xxiwYXddaGt+8rlzAcpWAtJzMptY6Imols1xir7BPHdaaSGEslbAsZj6KS7BlJz6WO4Z9gV40jC6A0bLevlJZX1bAbDp/by7/AJZmirPdOQVyqaWWprRUXyV5ZE2jbIaen3KQQMEHp/3jJj4gra5BRBjjFYBBnRjmT5SXh25t6rkvWouVluuVzlqGqmn/AIyqjPxGPU4SZen6du3HpphVAQs5uY2Y06V8onkFTXia5VPKWkpa+LNPFL83q52khJzhs1DAjIHf88Yxx3ggijBW9w95TeXZyX5MaaktOm+X9vt1vknNQ0UlVVTesoiZBaYkDaijA6dOG8MHc9oNIkt3bWtTbr+1Fuhhp4wn4rzOuwbFJyFU9Pt279s8QbqY0d7df3ntUKtHPM9apVpYxUqqgnarKzR+k9c56Y6Ht14U35SuNUN6yR8C+8ylMKSkgiJmbYhGZpmnc+pu7v6j/vi2A2txG03y3XuK/UDL7Iqcx5CHjEi7doygYfgAf43f39gf26ibdYsP5a53sNIjxRtHLEh3tKvUj2w6DPt/SPsOJZD5GOHxoNTZdB+IlkAWGEKFA2dApXH1H+0AfsONPD/htF1BuYPr9/WDuu1OndJXK70TywXGKDKTCRiVOQvYnHbp24oVEEB+VWs7rrPW0cNyuFVUxPDIxXeUyVHT6ccAYkO5EYcVlQaVO31JRajSLChpSF7bpWY/n3J/XhwoXYQHIz8zdZ//2Q==" }

![3!](https://images.cstrube.de/blog/images/swiftparkenappv006/3.webp){: w="800" h="600" lqip="data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAIBAQIBAQICAgICAgICAwUDAwMDAwYEBAMFBwYHBwcGBwcICQsJCAgKCAcHCg0KCgsMDAwMBwkODw0MDgsMDAz/2wBDAQICAgMDAwYDAwYMCAcIDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/wAARCAArABQDAREAAhEBAxEB/8QAGgAAAgMBAQAAAAAAAAAAAAAABQYDBAcICf/EADAQAAEDAgUCBQIGAwAAAAAAAAECAwQFEQAGBxIhCAkTIjFBcRQVIyUyQlFhgZHB/8QAGQEAAwEBAQAAAAAAAAAAAAAAAQIDAAQF/8QAJBEAAgICAQMEAwAAAAAAAAAAAQIAEQMhMRIiUQRBYYGhwfD/2gAMAwEAAhEDEQA/AOaKx23Okyjz3sstUPqZrjlJmyoT9QbrFBgoekx3FtODmEtxG4IU4lorXZJHyZhzdEV9/mE1ViUlduXpAbklEaidSD77BbU6heb6Gnwbsl5W/wDL1AEAWCT+s3At7sWABPiLfEMaZ9pvpf6r6fUK9T6vr1k5ulS/s7kNxNCqAeW0y0rxkuMNR0AFLiQQUFRUhSiolXFFWxdxTkANSbrM6iI+U+oLPFIlfc6i09VZ0kRi+5HW04XXEpaSQrw1bU7VDyDykBSja2OLBhd160Nb/crkzAdpWIsTUyNnHJD0JNGqLU+gPt1WM4yyVImsJbLfCSVqCkk38qjuF/YFOOkYXQGjZbz7SWV+rQGhx/bnb/bMyVR6poFUpMV2TNEiuOrdcRtG1wx4+5JBAsQeP+45MfqCtrkFEGOMVgEGejmpPZ/6etW80rreY9MadUqk9IVLU+ak+0ouK9TZDqfXjj09Megq400szbNmB8p9m7Qmn1OTVZmmNNblsAtNyG69KfswbqIWVOAW4Hrf5tg0hFQULuPGkHbq0U0hymadlbI9Oi0qS8ZISmoPykqVtS2SlZdVxZtIsDYW+cOFRtwdIm11OiSZM8ut1YR21hH4RYKtlkp9/wC7H/eItyY0kp9GqEeCFCsqcjR7rkD6QnxgFbiLEXPlG2wBwJpYMtmoMMvRk7GHEkoSWFMEDcf2KAI/yBf1xfEdQD5gKfl2dV83vJS3OjsOJbKJGwlgkIQebH04I+cRbmGFKbkd2nfTpU/PeVFVu3NSEttr8+8XCgSfYHnEyxugJFncGlW/uEaoFeOklstlQKikq32uo++OjCe3cqGZhbCjFvPk56h5LqUqK6tl+OwVNqBvtNx7HjFCohiJpPqFWcy50biTZ7j8dTLiijalPIHHIAOAAJpqK4jbhuoFR/kqJw9Caf/Z" }

Ein weiteres Highlight dieser Funktion ist die Paginierung, die für eine nahtlose Benutzererfahrung bei der Durchsicht der Historie sorgt.

```swift
VStack {
	// Griff
	RoundedRectangle(cornerRadius: 3)
		.fill(Color.gray)
		.frame(width: 50, height: 5)
		.padding(8)
	Text("Historie")
		.font(.headline)
		.padding(.bottom, 8)
	HistoryView(viewModel: HistoryViewModel(vehicleId: viewModel.vehicle.id))
}
```

### Abschluss

Mit diesen neuen Funktionen hoffen wir, dass Ihr Fahrzeugmanagement mit der Parken App noch effizienter und angenehmer wird. Wir arbeiten ständig daran, die App zu verbessern und sind gespannt auf Ihr Feedback!

---





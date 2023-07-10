---
title: "Optimizing an iOS Application: Case Study of the Parkplatzmanager App"
date: 2023-07-04 11:45:00 +0200
categories: ['iOS Development', 'Swift']
tags: ['ios', 'asynchronous programming', 'networking']
author: "Christian Strube"
image:
  path: https://images.cstrube.de/uploads/original/c4/85/426ac01432c4f36c3efe6e42c7d7.webp
  lqip: data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAYEBAQFBAYFBQYJBgUGCQsIBgYICwwKCgsKCgwQDAwMDAwMEAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/2wBDAQcHBw0MDRgQEBgUDg4OFBQODg4OFBEMDAwMDBERDAwMDAwMEQwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/wAARCAAPABQDAREAAhEBAxEB/8QAGAAAAgMAAAAAAAAAAAAAAAAAAgMEBgf/xAArEAABAwMBAw0AAAAAAAAAAAACARESAAMEIQUxUQYTFSIjM0FTYnGCodH/xAAYAQEAAwEAAAAAAAAAAAAAAAACAAMEAf/EACQRAAEDAgQHAAAAAAAAAAAAAAEAAhEDEgQiUWETIUFSkrLi/9oADAMBAAIRAxEAPwDL8jbmZiLbW1klbt3EIU3aKK6u4lxrokkgIVC1oBIm5KLlnti2CAOQpiSusVD76lMMdqqDiGaHy+VK6ay25yfbThL1Si8dz0J5StVuaN1Xci4tyzaHJtmAgpwJ0R3XXfwqCQTCFVrXAXGIlDbDCTzF+QflMOfoqODS7vVFPIk0C76Tv4zePvVfRbJzTuv/2Q==
---
In the last couple of days, we've embarked on an exciting journey of improving and optimizing an iOS application, the `parkplatzmanager` app. In this blog post, we will walk you through some of the changes we made and how they led to a more efficient and well-structured app. 

## Introduction

The `parkplatzmanager` app had been initially developed with a basic architecture, and as it grew in complexity, there were areas in the code that needed optimization and restructuring. Some of the issues we identified included ambiguous type inference, a lack of email validation, handling cache expiration, and dealing with data inconsistencies due to incorrect key-value mapping in the JSON response.

Let's walk through how we tackled each of these issues.

## 1. Resolving Ambiguous Type Inference

Swift, like many other languages, performs type inference to determine the type of an expression when it's not explicitly provided. However, sometimes the compiler might face difficulties in inferring the type of an expression, especially when multiple type possibilities exist. We encountered such an issue in the `ParkingService.swift` file:

```swift
return Promise { seal in
    firstly {
        RealDataRepository.shared.fetchUserData(userId: userId, groupId: groupId)
    }.done { vehicleData in
        do {
            // Process the data
            seal.fulfill(())
        } catch let error {
            seal.reject(error)
        }
    }.catch { error in
        seal.reject(error)
    }
}
```

Here, Swift was unable to infer the type of `vehicleData`. To resolve this, we explicitly provided the type of the `vehicleData`:

```swift
RealDataRepository.shared.fetchUserData(userId: userId, groupId: groupId)
}.done { (vehicleData: [Vehicle]) in
    do {
        // Process the data
        seal.fulfill(())
    } catch let error {
        seal.reject(error)
    }
```

## 2. Enforcing Email Validation

In the `InviteView.swift` file, we observed that the app did not validate emails, potentially leading to incorrect or invalid email addresses being accepted. 

We first introduced a method `isValidEmail(_ email: String) -> Bool` which was initially left as a placeholder. Later, we added a simple email validation logic:

```swift
private func isValidEmail(_ email: String) -> Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
    return emailTest.evaluate(with: email)
}
```

Furthermore, we made the text field in SwiftUI ignore auto-capitalization, ensuring that only lower case characters are allowed:

```swift
TextField("Email", text: $email)
    .keyboardType(.emailAddress)
    .autocapitalization(.none)
```

## 3. Handling Cache Expiration

Our app uses Redis for caching, and we identified a need to set a time-to-live (TTL) or expiration for our keys to control the freshness of the data. This can be done using the `EXPIRE` command in Redis:

```python
await redis.set(cache_key, json.dumps(vehicle))
await redis.expire(cache_key, 300)  # Set a TTL of 300 seconds
```

## 4. Addressing JSON Key-Value Mapping Inconsistencies

The application experienced crashes due to mismatches between the expected and received JSON data, particularly a missing `vehicle` key. We realized that the received JSON's structure was not what the app expected. 

To fix this, we updated our model to match

 the actual data received, ensuring that the keys in the Swift model matched the keys in the JSON data.

```swift
struct ResponseData: Codable {
    let status: String
    let data: [Vehicle]
}

struct Vehicle: Codable {
    let _id: String
    let fullName: String?
    let groupId: String
    let latitude: Double
    let licensePlate: String
    let longitude: Double
    let timestamp: String
    let userId: String
    let vehicleStatus: String
    let vin: String?
    
    enum CodingKeys: String, CodingKey {
        case _id
        case fullName
        case groupId = "group_id"
        case latitude
        case licensePlate = "license_plate"
        case longitude
        case timestamp
        case userId = "user_id"
        case vehicleStatus = "vehicle_status"
        case vin
    }
}
```

## Conclusion

Optimizing an app often involves refactoring and improving the existing code to ensure it's efficient, scalable, and maintainable. In our case, we were able to solve type inference ambiguity, improve data validation, handle cache expiration, and deal with JSON key-value inconsistencies. These changes significantly improved the `parkplatzmanager` app's robustness and efficiency, and we hope this walkthrough was insightful and helpful!
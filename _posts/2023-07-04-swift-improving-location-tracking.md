---
title: "Improving Location Tracking in an iOS Application: Case Study of the Parkplatzmanager App"
date: 2023-07-04
categories: ['iOS Development', 'Swift', 'App Optimization']
tags: ['swift', 'ios', 'combine', 'networking', 'app optimization', location tracking]
author: "Christian Strube"
image:
  path: https://images.cstrube.de/uploads/original/c4/85/426ac01432c4f36c3efe6e42c7d7.webp
  lqip: data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAYEBAQFBAYFBQYJBgUGCQsIBgYICwwKCgsKCgwQDAwMDAwMEAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/2wBDAQcHBw0MDRgQEBgUDg4OFBQODg4OFBEMDAwMDBERDAwMDAwMEQwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/wAARCAAPABQDAREAAhEBAxEB/8QAGAAAAgMAAAAAAAAAAAAAAAAAAgMEBgf/xAArEAABAwMBAw0AAAAAAAAAAAACARESAAMEIQUxUQYTFSIjM0FTYnGCodH/xAAYAQEAAwEAAAAAAAAAAAAAAAACAAMEAf/EACQRAAEDAgQHAAAAAAAAAAAAAAEAAhEDEgQiUWETIUFSkrLi/9oADAMBAAIRAxEAPwDL8jbmZiLbW1klbt3EIU3aKK6u4lxrokkgIVC1oBIm5KLlnti2CAOQpiSusVD76lMMdqqDiGaHy+VK6ay25yfbThL1Si8dz0J5StVuaN1Xci4tyzaHJtmAgpwJ0R3XXfwqCQTCFVrXAXGIlDbDCTzF+QflMOfoqODS7vVFPIk0C76Tv4zePvVfRbJzTuv/2Q==
---

In today's blog post, we'll be exploring how we can leverage Apple's SwiftUI and Combine frameworks to improve location tracking within our iOS apps. Our use case involves a parking management app, where we want to keep track of the user's current location to provide accurate services.

## Initial State

Initially, our code had a lack of continuous location updates while the user was interacting with the app. This could potentially lead to inaccurate location data, which would affect the functionality of our parking management app.

```swift
struct ParkingView: View {
    @EnvironmentObject var locationService: LocationService
    @State private var currentLocation: CLLocation?
    
    var body: some View {
        // Other views...
        
        .onAppear {
            os_log("Location updates started", log: viewLog, type: .debug)
            locationService.startLocationUpdates()
                .sink { location in
                    self.currentLocation = location
                    os_log("Current location: %@", log: viewLog, type: .debug, location.description)
                }
        }
    }
}
```

## Continuous Location Updates

To make location tracking more accurate, we decided to implement continuous location updates. 

First, we made changes in `LocationService` by replacing the `getCurrentLocation()` method with `startLocationUpdates()`. This method would return a publisher emitting new locations as they were updated by the `CLLocationManager`. 

```swift
class LocationService: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    private var locationSubject = PassthroughSubject<CLLocation, Never>()

    func startLocationUpdates() -> AnyPublisher<CLLocation, Never> {
	    locationManager.startUpdatingLocation()
	    return locationSubject.eraseToAnyPublisher()
    }
}
```

Next, we modified the SwiftUI `View`'s `.onAppear` method to subscribe to this publisher, storing the returned `AnyCancellable` in a `@State` property. This is important because we need to manage the lifecycle of the subscription and make sure it gets cancelled when the view disappears. 

In the `.onAppear` method, we started the location updates and stored the new location updates in `currentLocation`:

```swift
.onAppear {
    self.locationUpdateCancellable = self.locationService.startLocationUpdates()
        .sink { location in
            self.currentLocation = location
        }
}
```

To make sure that location updates stop when the view is no longer on screen, we added an `.onDisappear` method that cancels the subscription and stops location updates:

```swift
.onDisappear {
    self.locationService.stopUpdatingLocation()
    self.locationUpdateCancellable?.cancel()
}
```

## Enhanced Button Actions

We also improved the action buttons within the app. Each button has a role-based action which uses the camera to scan VIN numbers and license plates, and then sends the updated status of the vehicle to the backend. 

Here is an anonymized example of an action button within the `ParkingView`:

```swift
private func actionButton(title: String, iconName: String, statusText: String, action: @escaping () -> Void) -> some View {
    Button(action: {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                action()
                self.vehicleStatus = statusText
                self.isShowingScannerModal = true 
            } else {
                os_log("Camera access not granted", log: errorLog, type: .error)
            }
        }
    }) {


        HStack {
            Image(systemName: "qrcode")
            Text(title)
            Image(systemName: iconName)
        }
    }
    .padding()
    .background(Color.blue) 
    .foregroundColor(.white)
    .cornerRadius(10)
}
```

## Conclusion

With these changes, our location tracking is now more accurate and efficient. The use of Combine allowed us to reactively update our app's state based on the user's location, and SwiftUI made it easy to manage the lifecycle of these updates. Additionally, the role-based actions provide a user-friendly way to update vehicle statuses within the parking management app.

[YouTube Video Placeholder]

In our next post, we'll explore further improvements we can make to our parking management app using more advanced SwiftUI and Combine techniques. Stay tuned!

```
tags: [SwiftUI, Combine, iOS, Location Services]
```
//
//  Locationmanager.swift
//  Eats!
//
//  Created by Randy Hill on 8/22/21.
//

import CoreLocation

class Locations: NSObject, CLLocationManagerDelegate {
    static let shared = Locations()
    static let noPermissions = Notification.Name(rawValue: "NoLocationPermissions")
    
    let manager = CLLocationManager()
    var hasStarted = false
    var last: CLLocationCoordinate2D?
    
    func start() {
        guard !hasStarted else { return }
        
        manager.requestWhenInUseAuthorization()
        
        guard CLLocationManager.locationServicesEnabled() else {
            return notifyNoPermissions()
        }
        switch manager.authorizationStatus {
             case .notDetermined, .restricted, .denied:
                 return notifyNoPermissions()
             case .authorizedAlways, .authorizedWhenInUse:
                 break
             @unknown default:
                break
        }
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.startUpdatingLocation()
        hasStarted = true
    }
    
    private func notifyNoPermissions() {
        Log.error("User refused to give us permissions, how rude")
        NotificationCenter.default.post(Notification(name: Locations.noPermissions))
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let new: CLLocationCoordinate2D = manager.location?.coordinate else { return }
    
        if locationChanged(new: new, previous: last) {
            YelpRouter().getRestaurants(new)
        }
        last = new

    }
    
    // Only return true if we moved a minimum amount, as determined by our episilon constant.
    // If no previous location then location changed..
    private func locationChanged(new: CLLocationCoordinate2D, previous: CLLocationCoordinate2D?) -> Bool {
        guard let previous = previous else { return true }
        let epsilon: Double = 0.00001
        if fabs(new.latitude - previous.latitude) > epsilon {
            return true
        }
        if fabs(new.longitude - previous.longitude) > epsilon {
            return true
        }
        return false
    }
}

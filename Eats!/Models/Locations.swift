//
//  Locationmanager.swift
//  Eats!
//
//  Created by Randy Hill on 8/22/21.
//

import CoreLocation

class Locations: NSObject, CLLocationManagerDelegate {
    static let shared = Locations()
    
    let manager = CLLocationManager()
    var hasStarted = false
    var last: CLLocationCoordinate2D?
    
    func start() {
        guard !hasStarted else { return }
        
        manager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            manager.startUpdatingLocation()
            hasStarted = true
        }
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
        let epsilon: Double = 0.01
        if fabs(new.latitude - previous.latitude) > epsilon {
            return true
        }
        if fabs(new.longitude - previous.longitude) > epsilon {
            return true
        }
        return false
    }
}

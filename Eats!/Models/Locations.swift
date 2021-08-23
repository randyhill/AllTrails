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
        guard let newLocation: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        last = newLocation
    }
}

//
//  Database.swift
//  Eats!
//
//  Created by Randy Hill on 8/21/21.
//

import UIKit
import CoreLocation

class Database {
    static var data = [Restaurant]()
    
    static var dataRefreshed = Notification.Name(rawValue: "DataRefreshed")
    
    static var testData: [Restaurant] {
        return [
            Restaurant(name: "Chez Jose", image: UIImage(named: "martis-trail")!, rating: 5, cost: .medium, ratingCount: 1029, bodyText: "Best Tex Mex on west coast", location: CLLocationCoordinate2D(latitude: 45.463410, longitude: -122.683740), isFavorite: true)!,
            Restaurant(name: "Tee Pee", image: UIImage(named: "martis-trail")!, rating: 5, cost: .low, ratingCount: 828, bodyText: "Best Mexican in Phoenix", location: CLLocationCoordinate2D(latitude: 33.495370, longitude: -111.991480), isFavorite: true)!,
            Restaurant(name: "Ruth's Chris", image: UIImage(named: "martis-trail")!, rating: 5, cost: .high, ratingCount: 7072, bodyText: "Good steaks", location: CLLocationCoordinate2D(latitude: 33.539450, longitude: -111.924880), isFavorite: true)!,
            Restaurant(name: "In-N-Out Burger", image: UIImage(named: "martis-trail")!, rating: 4, cost: .cheap, ratingCount: 7072, bodyText: "Best drive through burgers", location: CLLocationCoordinate2D(latitude: 33.598999, longitude: -111.979683), isFavorite: true)!
        ]
    }
    
    static var locations: [CLLocationCoordinate2D] {
        return testData.map { model in
            return model.coordinate
        }
    }
    
    // Return true if initiated so we know if we can start spinner.
    static func fetchNewLocations() -> Bool {
        guard let currentLocation = Locations.shared.last else {
            Log.error("No current location to fetch data for")
            return false
        }
        YelpRouter().getRestaurants(currentLocation)
        return true
    }

    static func parseNewLocations(_ json: [String: Any]) {
        guard let businesses = json["businesses"] as? [[String: Any]] else {
            return Log.error("Could not find businesses in new JSON")
        }
        data.removeAll()
        for businessJSON in businesses {
            if let newRestaurant = Restaurant(json: businessJSON) {
                data.append(newRestaurant)
            }
        }
        let updateNotification = Notification(name: dataRefreshed, object: data)
        DispatchQueue.main.async {
            // Deliver notification on main queue to UI
            NotificationCenter.default.post(updateNotification)
        }
    }
}

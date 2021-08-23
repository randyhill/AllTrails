//
//  Restaurant.swift
//  Eats!
//
//  Created by Randy Hill on 8/21/21.
//

import UIKit
import CoreLocation
import MapKit

class Restaurant: Equatable {
    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
        if lhs.name != rhs.name { return false }
        
        // Comparing exact coordinates may not be a good idea depending upon data source.
        if lhs.coordinate.latitude != rhs.coordinate.latitude { return false }
        if lhs.coordinate.longitude != rhs.coordinate.longitude { return false }
        return true
    }
    
    enum Cost {
        case cheap, low, medium, high
        
        var dollarSigns: String {
            switch self {
            case .cheap:
                return "$"
            case .low:
                return "$$"
            case .medium:
                return "$$$"
            case .high:
                return "$$$$"
           }
        }
    }
    let name: String
    let image: UIImage      // Should be exterior of restaurant
    let rating: Int         // Max of 5 and we'll allow a zero rating because some restaurants deserve it
    let cost: Cost
    let ratingCount: Int    // How many ratings
    let description: String    // Short description of restaurant
    let coordinate: CLLocationCoordinate2D
    var isFavorite: Bool
    
    var bodyText: String {
        return cost.dollarSigns + " - " + description
    }
    
    var annotation: MKPointAnnotation {
        let annote = MKPointAnnotation()
        annote.coordinate = coordinate
        annote.title = name
        annote.subtitle = description
        return annote
    }
    
    // Only init if date is in proper ranges, to ensure we don't create garbage models and catch garbage data as soon as possible
    init?(name: String, image: UIImage, rating: Int, cost: Cost, ratingCount: Int, bodyText: String, location: CLLocationCoordinate2D, isFavorite: Bool) {
        guard rating >= 0 && rating <= 5 else {
            Log.error("Rating outside of 0 to 5 range, was: \(rating)")
            return nil
        }
        guard ratingCount >= 0 else {
            Log.error("Can't have negative rating counts, was: \(ratingCount)")
            return nil
        }
        guard location.longitude >= -180 && location.longitude <= 180 else {
            Log.error("Longitude outside of -180 to 180 range, in: \(location)")
            return nil
        }
        guard location.latitude >= -90 && location.latitude <= 90 else {
            Log.error("latitude outside of --90 to 90 range, was: \(location.latitude)")
            return nil
        }

        self.name = name
        self.image = image
        self.rating = rating
        self.cost = cost
        self.ratingCount = ratingCount
        self.description = bodyText
        self.coordinate = location
        self.isFavorite = isFavorite
    }
}


//
//  Restaurant.swift
//  Eats!
//
//  Created by Randy Hill on 8/21/21.
//

import UIKit
import CoreLocation

class Restaurant {
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
    let latitude: Double
    let longitude: Double
    var isFavorite: Bool
    
    var bodyText: String {
        return cost.dollarSigns + " - " + description
    }
    
    // Only init if date is in proper ranges, to ensure we don't create garbage models and catch garbage data as soon as possible
    init?(name: String, image: UIImage, rating: Int, cost: Cost, ratingCount: Int, bodyText: String, latitude: Double, longitude: Double, isFavorite: Bool) {
        guard rating >= 0 && rating <= 5 else {
            Log.error("Rating outside of 0 to 5 range, was: \(rating)")
            return nil
        }
        guard ratingCount >= 0 else {
            Log.error("Can't have negative rating counts, was: \(ratingCount)")
            return nil
        }
        guard longitude >= -180 && longitude <= 180 else {
            Log.error("Longitude outside of -180 to 180 range, was: \(longitude)")
            return nil
        }
        guard latitude >= -90 && latitude <= 90 else {
            Log.error("latitude outside of --90 to 90 range, was: \(latitude)")
            return nil
        }

        self.name = name
        self.image = image
        self.rating = rating
        self.cost = cost
        self.ratingCount = ratingCount
        self.description = bodyText
        self.latitude = latitude
        self.longitude = longitude
        self.isFavorite = isFavorite
    }
}


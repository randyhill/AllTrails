//
//  Database.swift
//  Eats!
//
//  Created by Randy Hill on 8/21/21.
//

import UIKit
import CoreLocation

class Database {
    static var testData: [Restaurant] {
        return [
            Restaurant(name: "Chez Jose", image: UIImage(named: "martis-trail")!, rating: 5, cost: .medium, ratingCount: 1029, bodyText: "Best Tex Mex on west coast", latitude: 0.0, longitude: 0.0, isFavorite: true)!,
            Restaurant(name: "Tee Pee", image: UIImage(named: "martis-trail")!, rating: 5, cost: .low, ratingCount: 828, bodyText: "Best Mexican in Phoenix", latitude: 0.0, longitude: 0.0, isFavorite: true)!,
            Restaurant(name: "Ruth's Chris", image: UIImage(named: "martis-trail")!, rating: 5, cost: .high, ratingCount: 7072, bodyText: "Good steaks", latitude: 0.0, longitude: 0.0, isFavorite: true)!,
            Restaurant(name: "In-N-Out Burger", image: UIImage(named: "martis-trail")!, rating: 4, cost: .cheap, ratingCount: 7072, bodyText: "Best drive through burgers", latitude: 0.0, longitude: 0.0, isFavorite: true)!,
            Restaurant(name: "Nick's Italian", image: UIImage(named: "martis-trail")!, rating: 3, cost: .medium, ratingCount: 128, bodyText: "Very good italian", latitude: 0.0, longitude: 0.0, isFavorite: true)!,
            Restaurant(name: "Olive Garden", image: UIImage(named: "martis-trail")!, rating: 4, cost: .low, ratingCount: 10293, bodyText: "Decent italian", latitude: 0.0, longitude: 0.0, isFavorite: false)!,
            Restaurant(name: "McDonalds", image: UIImage(named: "martis-trail")!, rating: 2, cost: .cheap, ratingCount: 44392, bodyText: "Fast cheap burgers", latitude: 0.0, longitude: 0.0, isFavorite: false)!,
            Restaurant(name: "PF Changs", image: UIImage(named: "martis-trail")!, rating: 4, cost: .medium, ratingCount: 1213, bodyText: "A chain but good chinese food", latitude: 0.0, longitude: 0.0, isFavorite: false)!,
            Restaurant(name: "Taco Bell", image: UIImage(named: "martis-trail")!, rating: 3, cost: .cheap, ratingCount: 19213, bodyText: "When you need some cheap mexican", latitude: 0.0, longitude: 0.0, isFavorite: false)!
        ]
    }
}

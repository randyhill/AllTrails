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
            Restaurant(name: "Ruth's Chris", image: UIImage(named: "martis-trail")!, rating: 5, cost: .high, ratingCount: 7072, bodyText: "Best drive through burgers", latitude: 0.0, longitude: 0.0, isFavorite: true)!,
            Restaurant(name: "In-N-Out Burger", image: UIImage(named: "martis-trail")!, rating: 4, cost: .cheap, ratingCount: 7072, bodyText: "Best drive through burgers", latitude: 0.0, longitude: 0.0, isFavorite: true)!,
            Restaurant(name: "Nick's Italian", image: UIImage(named: "martis-trail")!, rating: 3, cost: .medium, ratingCount: 128, bodyText: "Very good italian", latitude: 0.0, longitude: 0.0, isFavorite: true)!,
            Restaurant(name: "Olive Garden", image: UIImage(named: "martis-trail")!, rating: 4, cost: .low, ratingCount: 10293, bodyText: "Acceptable Italian", latitude: 0.0, longitude: 0.0, isFavorite: false)!,
            Restaurant(name: "McDonalds", image: UIImage(named: "martis-trail")!, rating: 2, cost: .cheap, ratingCount: 44392, bodyText: "Fast food", latitude: 0.0, longitude: 0.0, isFavorite: false)!
        ]
    }
}

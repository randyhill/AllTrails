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
    
    enum Cost: String  {
        case cheap = "$", low = "$$", medium = "$$$", high = "$$$$"
    }
    let name: String
    let rating: Int?         // 0-5, nil means not rated yet
    let cost: Cost?
    let ratingCount: Int    // How many ratings
    let description: String    // Short description of restaurant
    let coordinate: CLLocationCoordinate2D
    let imageURL: URL?
    var isFavorite: Bool

    private var _imageCached: UIImage?
    var image: UIImage?  {
        if let _image = _imageCached {
            return _image
        }
        return _imageCached
    }

    var bodyText: String {
        if let costString = cost?.rawValue {
            return costString + " - " + description
        }
        return description
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
        self._imageCached = image
        self.imageURL = nil
        self.rating = rating
        self.cost = cost
        self.ratingCount = ratingCount
        self.description = bodyText
        self.coordinate = location
        self.isFavorite = isFavorite
    }
    
    init?(json: [String: Any]) {
        guard let name = json["name"] as? String else {
            Log.error("Restaurant JSON missing name: \(json)")
            return nil
        }
        guard let coordinates = json["coordinates"] as? [String: Any] else {
            Log.error("Restaurant JSON missing coordinates: \(json)")
            return nil
        }
        guard let latitude = coordinates["latitude"] as? Double else {
            Log.error("Restaurant JSON missing latitude: \(json)")
            return nil
        }
        guard let longitude = coordinates["longitude"] as? Double else {
            Log.error("Restaurant JSON missing longitude: \(json)")
            return nil
        }
        guard let ratingCount = json["review_count"] as? Int else {
            Log.error("Restaurant JSON missing review_count: \(json)")
            return nil
        }
        
        // Some restaurants don't have prices yet.
        var cost: Cost?
        if let priceString = json["price"] as? String {
            cost = Cost(rawValue: priceString)
        }
        
        // Some restaurants don't have ratings yet so nil is an okay value.
        let rating = json["rating"] as? Int
        
        // Since Yelp doesn't return a description, lets make our own out of address, or phone if no address
        var description: String
        if let addressJSON = json["location"] as? [String: Any], let address = addressJSON["address1"] as? String {
            description = address
        } else {
            description = json["display_phone"] as? String ?? ""
        }

        self.name = name
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.rating = rating
        self.cost = cost
        self.ratingCount = ratingCount
        self.description = description
        self.isFavorite = false
        
        // Not sure if image path is always there, treated as optional just in case
        if let imagePath = json["image_url"] as? String {
            self.imageURL = URL(string: imagePath)
        } else {
            self.imageURL = nil
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    // Not guaranteed to return on main thread.
    func downloadImage(completion: @escaping (UIImage?)->Void) {
        guard let url = imageURL else {
            return Log.error("No image URL for: \(name)")
        }
        getData(from: url) { data, response, error in
            guard let data = data else {
                let errorString = error?.localizedDescription ?? "unknown"
                Log.error("Image fetch for: \(url) failed, error: \(errorString)")
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            self._imageCached = image
            completion(image)
        }
    }
}


//
//  YelpRouter.swift
//  Eats!
//
//  Created by Randy Hill on 8/22/21.
//

import CoreLocation

class YelpRouter {
    private let clientId = "2-qToWw_vmFE_3vR9U1-CQ"
    private let apiKey = "NNY1oeSy7Ropgm4Djx5Nb7U4PIybJJs96anvQdzDq1oo7xP3jQiyXqT_tBTv6dnQtAsSK0iiFllhjJelFHEDQR1eiMQMqWsf9GKG4FwDyCrcIOgrIwE7wUGzHzQjYXYx"
    private let secretKey = ""
    
    func getRestaurants(_ coordinates: CLLocationCoordinate2D) {
//        let params: [String: Any] =
//            ["term": "restaurants",
//             "latitude": "\(coordinates.latitude)",
//             "longitude": "\(coordinates.longitude)",
//             "key": apiKey
//            ]
        let params = "?term=restaurants&latitude=\(coordinates.latitude)&longitude=\(coordinates.longitude)"

        var request = URLRequest(url: URL(string: "https://api.yelp.com/v3/businesses/search\(params)")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
  
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            guard let response = response else {
                guard let error = error else { return Log.error("Unknown error returned from Yelp API")}
                return Log.error("Yelp API returned error: \(error)")
            }
            guard let data = data else {
                return Log.error("Yelp API returned nil data with no error: \(response)")
            }
            do {
                print(response)
                guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    return Log.error("Could not parse data from Yelp: \(response)")
                }
                print(json)
            } catch {
                print("Parsing JSON generated the following error: \(error)")
            }
        })

        task.resume()
    }
}

//
//  MkAnnotation+Eats.swift
//  Eats!
//
//  Created by Randy Hill on 8/22/21.
//

import MapKit

extension CLLocationCoordinate2D {
    var annotation: MKPointAnnotation {
        let annote = MKPointAnnotation()
        annote.coordinate = self
        return annote
    }
}

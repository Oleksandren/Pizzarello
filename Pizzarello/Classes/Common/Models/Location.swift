//
//  Location.swift
//  Pizzarello
//
//  Created by Oleksandr Nechet on 26.07.17.
//  Copyright © 2017 Oleksandr Nechet. All rights reserved.
//

import Foundation
import CoreLocation

struct Location
{
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double,
        longitude: Double)
    {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(_ location: CLLocationCoordinate2D)
    {
        latitude = location.latitude
        longitude = location.longitude
    }
}

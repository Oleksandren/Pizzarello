//
//  LocationManager.swift
//  Pizzarello
//
//  Created by Oleksandr Nechet on 25.07.17.
//  Copyright © 2017 Oleksandr Nechet. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject
{
    static let shared = LocationManager()
    fileprivate let manager = CLLocationManager()
    var location: Location? {
        didSet {
            if let loc = location {
                locationDidUpdated?(loc)
            }
        }
    }
    var locationDidUpdated: ((_ location: Location) -> Void)?
    
    //MARK: - Object lifecycle
    
    private override init()
    {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.distanceFilter = 500
        if CLLocationManager.locationServicesEnabled()
        {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    //MARK: - Helpers
    func startUpdatingLocation()
    {
        manager.startUpdatingLocation()
    }
}

//MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        if let loc = locations.first?.coordinate {
            location = Location(loc)
        }
        else {
            location = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print(error.localizedDescription)
    }
}

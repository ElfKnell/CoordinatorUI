//
//  CoreLocation.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 17/10/2022.
//

import CoreLocation

class LocationFetcher: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var lastKnownLocation: CLLocationCoordinate2D?
    var lon = 0.0

    override init() {
        super.init()
        manager.delegate = self
    }

    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        print("..............")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
        
        guard let lkl = lastKnownLocation?.longitude else { return }
        lon = lkl
        print(lon)
    }
    
    func loc() {
        print(lon)
    }
}

//
//  CoreLocation.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 17/10/2022.
//

import CoreLocation
import MapKit

class LocationFetcher: NSObject, CLLocationManagerDelegate, ObservableObject {
    let manager = CLLocationManager()
    var lastKnownLocation: CLLocationCoordinate2D?
    var coordinateRegion: MKCoordinateRegion?

    override init() {
        super.init()
        manager.delegate = self
    }

    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
        
        guard let latitude = lastKnownLocation?.latitude else { return }
        
        
        guard let longitude = lastKnownLocation?.longitude else { return }
        
        coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20))

    }

}

//
//  LocationEdit.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 11/02/2023.
//

import Foundation
import MapKit

class LocationEdit: ObservableObject {
    
    @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50.0, longitude: -70.0), span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20))
    
    @Published private(set) var locations: [Location]
    
    @Published var latitude: String = ""
    @Published var longitude: String = ""
    
    init() {
        do {
            let data = try Data(contentsOf: FileManager.savePath)
            locations = try JSONDecoder().decode([Location].self, from: data)
        } catch {
            locations = []
        }
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(locations)
            try data.write(to: FileManager.savePath, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
    
    func addLocation() {
        let newLocation = Location(id: UUID(), name: "New location", description: "unknown", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
        locations.append(newLocation)
        save()
    }
    
    func updateLocation(_ selectedPlace:Location?, location: Location) {
        
        guard let place = selectedPlace else {
            return
        }

        if let index = locations.firstIndex(of: place) {
            locations[index] = location
            save()
        } else {
            return
        }
    }
    
    func changeLocation() {
        
        guard let lat = Double(latitude) else {
            return
        }
        guard let lon = Double(longitude) else {
            return
        }
        if (lat < -90.0 || lat > 90.0) || (lon < -180.0 || lon > 180.0) {
            return
        } else {
            mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20))
        }
    }
}

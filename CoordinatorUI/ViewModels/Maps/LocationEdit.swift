//
//  LocationEdit.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 11/02/2023.
//

import Foundation
import MapKit

class LocationEdit: ObservableObject {
    
    private var locations: [Location] = []
    
    init() {
        do {
            let data = try Data(contentsOf: FileManager.savePath)
            locations = try JSONDecoder().decode([Location].self, from: data)
        } catch {
            locations = []
        }
    }
    
    func loc() -> [Location] {
        let locations: [Location]
        do {
            let data = try Data(contentsOf: FileManager.savePath)
            locations = try JSONDecoder().decode([Location].self, from: data)
        } catch {
            locations = []
        }
        return locations
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(locations)
            try data.write(to: FileManager.savePath, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
    
    func addLocation(mapRegion: MKCoordinateRegion) {
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
    
}

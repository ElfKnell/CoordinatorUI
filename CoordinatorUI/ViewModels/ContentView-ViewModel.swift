//
//  ContentView-ModelView.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 26/06/2022.
//

import Foundation
import MapKit

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        @Published var isUnlocked = true
        
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50.0, longitude: -70.0), span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20))
        
        @Published private(set) var locations: [Location]
        
        @Published var selectedPlace: Location?
        
        let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        func addLocation() {
            let newLocation = Location(id: UUID(), name: "New location", description: "unknown", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
            locations.append(newLocation)
            save()
        }
        
        func updateLocation(location: Location) {
            guard let place = selectedPlace else {
                return
            }
            if let index = locations.firstIndex(of: place) {
                locations[index] = location
                save()
            }
        }
    }
}

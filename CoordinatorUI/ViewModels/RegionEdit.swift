//
//  Region.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 22/02/2023.
//

import Foundation
import MapKit


class RegionEdit: ObservableObject {
    
    static let mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 45.7878, longitude: 5.7754), span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20))
    
    private let fileNameRegion = "region.json"
    
     private let fileManager = FileManager()
    
    @Published var region: Region
    
    init() {
        fileManager.setFileName(self.fileNameRegion)
        
        do {
            let data = try fileManager.readDocument()
            region = try JSONDecoder().decode(Region.self, from: data)    
        } catch {
            region = Region.example
        }
    }
    
    func changeRegion(latitude: String, longitude: String) throws -> MKCoordinateRegion {
        
        guard let lat = Double(latitude) else {
            throw ErrorRegion.notDoubleLanitude
        }
        guard let lon = Double(longitude) else {
            throw ErrorRegion.notDoubleLongitude
        }
        
        if (lat < -90.0 || lat > 90.0) {
            throw ErrorRegion.exceededLanitude
        } else if (lon < -180.0 || lon > 180.0) {
            throw ErrorRegion.exceededLongitude
        } else {
            return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20))
        }
    }
    
    func saveRegion(_ region: Region) {
        
        let encoder = JSONEncoder()
        fileManager.setFileName(self.fileNameRegion)
        
        do {
            let data = try encoder.encode(region)
            let jsonString = String(decoding: data, as: UTF8.self)
            
            try fileManager.saveDocument(contents: jsonString)
        } catch {
            print("Unable to save data.")
        }
    }
    
}

//
//  StartRegion.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 05/03/2023.
//

import Foundation
import MapKit

class StartRegion: ObservableObject {
    
    @Published var startRegion: MKCoordinateRegion
    
    init(_ location: MKCoordinateRegion? ) {
        let regionEdit = RegionEdit()
        
        guard let startR = location else {
            startRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: regionEdit.region.lanitude, longitude: regionEdit.region.longitude), span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20))
            return
        }
        startRegion = startR
    }
}

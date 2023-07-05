//
//  Region.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 04/03/2023.
//

import Foundation
import MapKit

struct Region: Identifiable, Codable {
    var id: UUID
    var longitude: Double
    var lanitude: Double
    
    static let example = Region(id: UUID(), longitude: 0.0, lanitude: 0.0)
    
    static func decoder(_ mkCoordinate: MKCoordinateRegion) -> Region {
        Region(id: UUID(), longitude: mkCoordinate.center.longitude, lanitude: mkCoordinate.center.latitude)
    }
}

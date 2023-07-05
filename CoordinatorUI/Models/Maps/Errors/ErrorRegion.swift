//
//  ErrorRegion.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 12/03/2023.
//

import Foundation

enum ErrorRegion: Error, LocalizedError {
    case notDoubleLanitude
    case notDoubleLongitude
    case exceededLanitude
    case exceededLongitude
    
    var errorDescription: String? {
        switch self {
        case .notDoubleLanitude:
            return NSLocalizedString("Lanitude value cann't be converted to double", comment: "")
        case .notDoubleLongitude:
            return NSLocalizedString("Longitude value cann't be converted to double", comment: "")
        case .exceededLanitude:
            return NSLocalizedString("Lanitude value was exceeded", comment: "")
        case .exceededLongitude:
            return NSLocalizedString("Longitude value was exceeded", comment: "")
        }
    }
}

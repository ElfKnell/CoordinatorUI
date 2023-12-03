//
//  PhotosVMError.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 09/10/2023.
//

import Foundation

enum PhotosVMError: Error {
    case invalidId
    
    var errorDescription: String {
        switch self {
        case .invalidId:
            return NSLocalizedString("Invalid id photo", comment: "")
        }
    }
}

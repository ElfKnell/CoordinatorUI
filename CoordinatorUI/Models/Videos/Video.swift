//
//  Video.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 04/09/2023.
//

import Foundation

struct Video: Identifiable, Decodable {
    var id: String {
        return NSUUID().uuidString
    }
    let videoURL: String
}

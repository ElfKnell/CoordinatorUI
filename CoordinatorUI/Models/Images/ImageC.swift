//
//  ImageC.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 04/10/2023.
//

import Foundation
import FirebaseFirestoreSwift

struct ImageC: Identifiable, Codable {
    var id: String
    let name: String
    let photoURL: String
    @DocumentID var documentId: String?
}

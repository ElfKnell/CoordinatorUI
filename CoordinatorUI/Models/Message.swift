//
//  Message.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 23/06/2022.
//

import Foundation

struct Message: Identifiable {
    let id = UUID()
    let chartId: UUID
    let sender: String
    let content: String
    let date: Date
}

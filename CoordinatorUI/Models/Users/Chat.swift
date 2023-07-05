//
//  Chat.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 23/06/2022.
//

import Foundation

struct Chat: Identifiable {
    let id = UUID()
    let adminId: UUID
    let usersId: [UUID]
    let title: String
    let subtitle: String
}

//
//  Users.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 23/06/2022.
//

import Foundation

struct User: Identifiable {
    
    let id = UUID()
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    
}

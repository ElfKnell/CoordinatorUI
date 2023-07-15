//
//  MessageService.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 05/07/2023.
//

import Foundation

protocol MessageService {
    
    func getUser() -> User
    func gerChat() -> Chat
    
    func getMessage() -> Message
}

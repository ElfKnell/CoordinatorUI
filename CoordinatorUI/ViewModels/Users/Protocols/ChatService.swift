//
//  ChatService.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 23/06/2022.
//

import Foundation

protocol ChatService {
    
    var adminUser: User { get }
    
    func fetchChats() -> [Chat]
    func fetchUsers() -> [User]
    func fetchMessages() -> [Message]
    
    @discardableResult
    func addMessage(_ content: String, to chat: Chat) throws -> Message
}

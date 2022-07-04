//
//  FileManagerDocument.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 26/06/2022.
//

import Foundation

let fileNane = ""

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func docExist(named docName: String) -> Bool {
        fileExists(atPath: Self.documentsDirectory.appendingPathComponent(docName).path)
    }
}

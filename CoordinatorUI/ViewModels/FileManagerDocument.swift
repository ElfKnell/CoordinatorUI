//
//  FileManagerDocument.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 26/06/2022.
//

import Foundation
import UIKit

let fileNane = "MyImages.json"

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func docExist(named docName: String) -> Bool {
        fileExists(atPath: Self.documentsDirectory.appendingPathComponent(docName).path)
    }
    
    func saveDocument(contents: String) throws {
        let url = Self.documentsDirectory.appendingPathComponent(fileNane)
        do {
            try contents.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            throw MyImageError.saveError
        }
    }
    
    func readDocument() throws -> Data {
        let url = Self.documentsDirectory.appendingPathComponent(fileNane)
        do {
            return try Data(contentsOf: url)
        } catch {
            throw MyImageError.readError
        }
    }
    
    func saveImage(_ id: String, image: UIImage) throws {
        if let data = image.jpegData(compressionQuality: 0.6) {
            let imageURL = FileManager.documentsDirectory.appendingPathComponent("\(id).jpg")
            do {
                try data.write(to: imageURL)
            } catch {
                throw MyImageError.saveImageError
            }
        } else {
            throw MyImageError.saveImageError
        }
    }
    
    func readImage(with id: UUID) throws -> UIImage {
        let imageURL = FileManager.documentsDirectory.appendingPathComponent("\(id).jpg")
        do {
            let imageData = try Data(contentsOf: imageURL)
            if let image = UIImage(data: imageData) {
                return image
            } else {
                throw MyImageError.readImageError
            }
        } catch {
            throw MyImageError.readImageError
        }
    }
}

//
//  PhotoUploader.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 04/10/2023.
//

import Foundation
import FirebaseStorage

struct PhotoUploader {
    
    static var location = "location"
    
    static func uploaderPhoto(withData photoData: Data) async throws -> (photoURL:String?, fileName: String) {
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference().child("photos/\(location)/photo/\(filename)")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        do {
            let _ = try await ref.putDataAsync(photoData, metadata: metadata)
            let url = try await ref.downloadURL()
            return (url.absoluteString, filename)
        } catch {
            return (nil, filename)
        }
    }
}

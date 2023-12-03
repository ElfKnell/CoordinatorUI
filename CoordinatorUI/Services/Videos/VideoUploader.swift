//
//  VideoUploader.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 04/09/2023.
//

import Foundation
import FirebaseStorage

struct VideoUploader {
    
    static var location = "location"
    
    static func uploadVideo(withData videoData: Data) async throws -> String? {
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference().child("videos/\(location)/video/\(filename)")
        
        let metadata = StorageMetadata()
        metadata.contentType = "video/quicktime"
        
        do {
            let _ = try await ref.putDataAsync(videoData, metadata: metadata)
            let url = try await ref.downloadURL()
            return url.absoluteString
        } catch {
            return nil
        }
    }
}

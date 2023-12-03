//
//  VideoViewModel.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 03/09/2023.
//

import Foundation
import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage

class VideoViewModel: ObservableObject {
    
    @Published var videos = [Video]()
    
    @Published var selectedItem: PhotosPickerItem? {
        didSet { Task { try await uploadVideo() } }
    }
    
    @Published var isLoaded = true
    
    init() {
        Task { try await fetchVideos() }
    }
    
    @MainActor
    func uploadVideo() async throws {
        isLoaded = false
        
        guard let item = selectedItem else { return }
        guard let videoData = try await item.loadTransferable(type: Data.self) else { return }
        
        guard let videoURL = try await VideoUploader.uploadVideo(withData: videoData) else { return }
        
        try await Firestore.firestore().collection("videos").document().setData(["videoURL": videoURL])
        
        isLoaded = true
        
        Task { try await fetchVideos() }
    }
    
    @MainActor
    func fetchVideos() async throws {
        let snapshot = try await Firestore.firestore().collection("videos").getDocuments()
        
        self.videos = snapshot.documents.compactMap({ try? $0.data(as: Video.self) })
    }
    
    @MainActor
    func filterVideo(_ locationId: String) -> [Video] {
        
        var filtersVideo = [Video]()
        
        for video in videos {
            if video.videoURL.contains(locationId) {
                filtersVideo.append(video)
            }
        }
        
        return filtersVideo
    }
}

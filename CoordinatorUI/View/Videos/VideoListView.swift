//
//  VideoListView.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 03/09/2023.
//

import SwiftUI
import PhotosUI
import AVKit

struct VideoListView: View {
    
    @StateObject var videoViewModel = VideoViewModel()
    
    var videos: [Video] {
        videoViewModel.filterVideo(location)
    }
    
    var location: String
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                BackgroundView()
                
                if !videoViewModel.isLoaded {
                    LoadingView()
                } else {
                    ScrollView {
                        ForEach(videos) { video in
                            VideoPlayer(player: AVPlayer(url: URL(string: video.videoURL)!))
                                .frame(height: 250)
                        }
                    }
                    .refreshable {
                        Task { try await videoViewModel.fetchVideos() }
                    }
                    .onAppear {
                        VideoUploader.location = location
                    }
                    .navigationTitle("Video")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            
                            PhotosPicker(selection: $videoViewModel.selectedItem, matching: .any(of: [.videos, .not(.images)])) {
                                Image(systemName: "plus")
                                    .foregroundColor(.black)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct VideoListView_Previews: PreviewProvider {
    static var previews: some View {
        VideoListView(location: "location")
    }
}

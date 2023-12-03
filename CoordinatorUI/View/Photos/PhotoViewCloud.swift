//
//  PhotoViewCloud.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 09/10/2023.
//

import SwiftUI
import PhotosUI

struct PhotoViewCloud: View {
    
    @StateObject var photoVM = PhotoViewModel()
    
    var photos: [ImageC] {
        photoVM.filterPhotos(location)
    }
    
    var location: String
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                BackgroundView()
                
                VStack {
                    
                    if !photos.isEmpty {
                        photoScroll
                    }
                    
                    Spacer()
                    
                    if photoVM.isLoaded {
                        LoadingView()
                    } else {
                        selectedPhoto
                    }
                    
                    if photoVM.selectedImage != nil || photoVM.photo != nil {
                        saveUpdateButtons
                    }
                    
                    selectButton
                    
                    Spacer()
 
                }
                .onAppear() {
                    PhotoUploader.location = location
                }
            }
        }
    }
}

#Preview {
    PhotoViewCloud(location: "location")
}

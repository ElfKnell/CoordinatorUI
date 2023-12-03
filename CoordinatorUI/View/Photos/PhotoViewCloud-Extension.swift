//
//  PhotoViewCloud-Extension.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 25/11/2023.
//

import SwiftUI
import PhotosUI

extension PhotoViewCloud {
    
    var photoScroll: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    
                    ForEach(photos) { photo in
                        VStack {
                            
                            AsyncPhotoView(photo: photo)
                            
                            Text(photo.name)
                                .foregroundColor(.blue)
                        }
                        .padding(.horizontal, 3)
                        .onTapGesture {
                            photoVM.setPhoto(photo: photo)
                            photoVM.name = photo.name
                        }
                    }
                }
            }
            .frame(height: 150)
            .padding(.vertical)
        }
    }
    
    var selectPhoto: some View {
        Group {
            if let image = photoVM.selectedImage {
                NavigationLink(destination: BigPhotoView(img: image)) {
                    UIImageView(uiImage: image)
                }
            } else {
                PhotosPicker(selection: $photoVM.selectedPhoto, matching: .any(of: [.images, .not(.videos)])) {
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFit()
                }
            }
        }
    }
    
    var selectedPhoto: some View {
        
        Group {
            if photoVM.photo != nil {
                NavigationLink(destination: BigPhotoView(photoCloud: photoVM.photo)) {
                    AsyncPhotoView(photo: photoVM.photo)
                }
            } else {
                selectPhoto
            }
        }
        .padding()
    
    }
    
    var selectButton: some View {
        HStack {
            
            NavigationLink {
                CameraView()
            } label: {
                ButtonLabel(symbolLabel: "camera.circle.fill", label: "Camera")
            }
            .padding(.horizontal)
            
            PhotosPicker(selection: $photoVM.selectedPhoto, matching: .any(of: [.images, .not(.videos)])) {
                ButtonLabel(symbolLabel: "photo", label: "Photo")
            }
            .padding(.horizontal)
          
        }
    }
    
    var saveUpdateButtons: some View {
        VStack {
            
            TextField("Name photo", text: $photoVM.name)
                .font(.system(size: 20, design: .serif))
                .frame(width: 300, height: 25)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom)
            
            HStack {
                
                Spacer()
                
                Button {
                    Task {
                        try await photoVM.save0rUpdate(name:photoVM.name)
                    }
                } label: {
                    ButtonLabel(symbolLabel: photoVM.photo == nil ? "square.and.arrow.down.fill" : "square.and.arrow.up.fill", label: photoVM.photo == nil ? "Save" : "Update")
                }
                
                Spacer()
                
                if photoVM.photo != nil {
                    Button {
                        Task {
                            try await photoVM.deletePhoto()
                        }
                    } label: {
                        ButtonLabel(symbolLabel: "trash.circle.fill", label: "Delete")
                    }
                } else {
                    Button {
                        photoVM.cansel()
                    } label: {
                        ButtonLabel(symbolLabel: "xmark.circle.fill", label: "Cancel")
                    }
                }
                
                Spacer()
            }
        }
        .padding()
    }
}

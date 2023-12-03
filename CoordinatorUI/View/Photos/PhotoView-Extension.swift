//
//  PhotoView-Extension.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 15/07/2022.
//

import SwiftUI

extension PhotoView {

    var imageScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                
                ForEach(photoModel.myImages) { myImage in
                    VStack {
                        
                        UIImageView(uiImage: myImage.image)
                        
                        Text(myImage.name)
                            .foregroundColor(.white)
                    }
                    .onTapGesture {
                        photoModel.display(myImage)
                    }
                }
            }
        }
        .frame(height: 140)
        .padding(.vertical)
    }
    
    var selectedImage: some View {
        Group {
            if let image = photoModel.image {
                NavigationLink(destination: BigPhotoView(img: image)) {
                    UIImageView(uiImage: image)
                }
            } else {
                Image(systemName: "photo.fill")
                    .resizable()
                    .scaledToFit()
                    .onTapGesture {
                        photoModel.isShovingPhotoPicker = true
                    }
            }
        }
        .padding()
    }
    
    var editGroup: some View {
        Group {
            TextField("Image name", text: $photoModel.imageName) { isEditing in
                photoModel.isEditing = isEditing
            }
            .focused($nameField, equals: true)
            .textFieldStyle(.roundedBorder)
            
            HStack {
                Spacer()
                
                Button {
                    if photoModel.selectedImage == nil {
                        photoModel.addMyImage(photoModel.imageName, image: photoModel.image!)
                        nameField = false
                    } else {
                        photoModel.updateSelected()
                        nameField = false
                    }
                } label: {
                    ButtonLabel(symbolLabel: photoModel.selectedImage == nil ? "square.and.arrow.down.fill" : "square.and.arrow.up.fill", label: photoModel.selectedImage == nil ? "Save" : "Update")
                }
                .disabled(photoModel.buttonDisabled)
                .opacity(photoModel.buttonDisabled ? 0.6 : 1)
                
                Spacer()
                
                if !photoModel.deleteButtonIsHidden {
                    Button {
                        photoModel.deleteSelected()
                    } label: {
                        ButtonLabel(symbolLabel: "trash", label: "Delete")
                    }
                }
                Spacer()
            }
        }
        .padding()
        
    }
    
    var pickerButton: some View {
        HStack {
            Spacer()
            
            Button {

                photoModel.addPhoto(status: .camera)
            } label: {
                ButtonLabel(symbolLabel: "camera", label: "Camera")
            }
            .alert("Error", isPresented: $photoModel.showCameraAlert, presenting: photoModel.cameraError) { cameraError in
                cameraError.button
            } message: { cameraError in
                Text(cameraError.message)
            }
            
            Spacer()
            
            Button {
                locationFetcher.start()
                photoModel.addPhoto(status: .photo)
            } label: {
                ButtonLabel(symbolLabel: "photo", label: "Photo")
            }
            
            Spacer()
        }
    }
}


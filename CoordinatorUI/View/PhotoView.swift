//
//  PhotoView.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 28/06/2022.
//

import SwiftUI

struct PhotoView: View {
    
    @StateObject private var photoModel = PhotoModel()
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        
                        if !photoModel.images.isEmpty {
                                
                            ForEach(0..<photoModel.indexC, id:\.self) { index in
                                Image(uiImage: photoModel.images[index])
                                        .resizable()
                                        .scaledToFit()
                                        .onTapGesture {
                                            photoModel.image = photoModel.images[index]
                                        }
                                }
 
                            } else {
                                Image(systemName: "photo.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .onTapGesture {
                                        photoModel.image = UIImage(systemName: "photo.fill")!
                                    }
                            }
                        
                    }
                }
                .frame(height: 140)

                Spacer()
                
                Image(uiImage: photoModel.image)
                    .resizable()
                    .scaledToFit()
                    .zoomable(scale: $photoModel.scale)
//                    .onTapGesture {
//                        isShovingPhotoPicker = true
//                        images.append(image)
//                        indexC += 1
//                    }
                
                Spacer()
                
                VStack {
                    TextField("Image name", text: $photoModel.imageName) { isEditing in
                        photoModel.isEditing = isEditing
                    }
                        .textFieldStyle(.roundedBorder)
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            if photoModel.selectedImage == nil {
                                photoModel.addMyImage(photoModel.imageName, image: photoModel.image)
                            }
                        } label: {
                            ButtonLabel(symbolLabel: photoModel.selectedImage == nil ? "square.and.arrow.down.fill" : "square.and.arrow.up.fill", label: photoModel.selectedImage == nil ? "Save" : "Update")
                        }
                        .disabled(photoModel.buttonDisabled)
                        .opacity(photoModel.buttonDisabled ? 0.6 : 1)
                        
                        Spacer()
                        
                        if !photoModel.deleteButtonIsHidden {
                            Button {
                                
                            } label: {
                                ButtonLabel(symbolLabel: "trash", label: "Delete")
                            }
                        }
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            photoModel.addPhoto(status: .camera)
                        } label: {
                            ButtonLabel(symbolLabel: "camera", label: "Camera")
                        }
                        
                        Spacer()
                        
                        Button {
                            photoModel.addPhoto(status: .photo)
                        } label: {
                            ButtonLabel(symbolLabel: "photo", label: "Photo")
                        }
                        
                        Spacer()
                    }
                }
                
                Spacer()
                
                HStack {
                    Button {
                        photoModel.scale = 1
                    } label: {
                        ButtonLabel(symbolLabel: "gobackward", label: "Reset")
                    }
                    Spacer()
                    Text("Zoom: \(String(format: "%.02f", photoModel.scale * 100) )%")
                }
                .padding()
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $photoModel.isShovingPhotoPicker) {
                    PhotoPicker(image: $photoModel.image, sourceType: photoModel.status == .photo ? .photoLibrary : .camera)
                    .ignoresSafeArea()
            }
            .alert("Error", isPresented: $photoModel.showCameraAlert, presenting: photoModel.cameraError) { cameraError in
                cameraError.button
            } message: { cameraError in
                Text(cameraError.message)
            }

        }
        
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoView()
    }
}

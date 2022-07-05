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
                
                HStack{
                    Spacer()
                    
                    Button {
                        photoModel.isShovingPhotoPicker = true
                        photoModel.status = .camera
                        photoModel.images.append(photoModel.image)
                        photoModel.indexC += 1
                    } label: {
                        Text("Camera")
                        
                    }
                    
                    Spacer()
                    
                    Button {
                        photoModel.isShovingPhotoPicker = true
                        photoModel.status = .photo
                        photoModel.images.append(photoModel.image)
                        photoModel.indexC += 1
                    } label: {
                        Text("Photos")
                    }
                    
                    Spacer()
                }
                
                Spacer()
                
                HStack {
                    Button("Reset") {
                        photoModel.scale = 1
                    }
                    Spacer()
                    Text("Zoom: \(String(format: "%.02f", photoModel.scale * 100) )%")
                }
                .padding()
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $photoModel.isShovingPhotoPicker) {
                switch photoModel.status {
                case .photo:
                    PhotoPicker(image: $photoModel.image, sourceType: .photoLibrary)
                case .camera:
                    PhotoPicker(image: $photoModel.image, sourceType: .camera)
                }
                
            }
        }
        
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoView()
    }
}

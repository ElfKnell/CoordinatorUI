//
//  PhotoView.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 28/06/2022.
//

import SwiftUI

struct PhotoView: View {
    
    @StateObject var photoModel = PhotoModel()
    @FocusState var nameField: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                if !photoModel.isEditing {
                    imageScroll
                }
                
                selectedImage
                
                VStack {
                    if photoModel.image != nil {
                        editGroup
                    }
                    if !photoModel.isEditing {
                        pickerButton
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
            .task {
                if FileManager().docExist(named: fileNane) {
                    photoModel.loadMyImageJSONFile()
                }
            }
            .sheet(isPresented: $photoModel.isShovingPhotoPicker) {
                
                    PhotoPicker(image: $photoModel.image, sourceType: photoModel.status == .photo ? .photoLibrary : .camera)
                    .ignoresSafeArea()
            }
            .alert("Error", isPresented: $photoModel.showFileAlert, presenting: photoModel.appError) { cameraError in
                cameraError.button
            } message: { cameraError in
                Text(cameraError.message)
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button {
                            nameField = false
                        } label: {
                            Image(systemName: "keyboard.chevron.compact.down")
                        }
                    }
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

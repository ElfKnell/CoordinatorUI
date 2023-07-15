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
    
    var newNameFile: String
    
    let locationFetcher = LocationFetcher()
    
    var body: some View {
        ZStack(alignment: .top) {
                
                RadialGradient(stops: [
                    .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                    .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)], center: .top, startRadius: 200, endRadius: 700)
                    .ignoresSafeArea()
                
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
                }
                .navigationTitle("Add photo")
                .task {
                    FileManager().setFileName(newNameFile)
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
        NavigationView {
            PhotoView(newNameFile: "")
        }
    }
}

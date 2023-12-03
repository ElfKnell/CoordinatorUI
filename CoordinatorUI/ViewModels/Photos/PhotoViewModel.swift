//
//  PhotoViewModel.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 08/10/2023.
//

import Foundation
import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage

class PhotoViewModel: ObservableObject {
    
    @Published var photos = [ImageC]()
    @Published var isLoaded = false
    @Published var photo: ImageC?
    @Published var name: String = ""
    
    @Published var selectedImage: UIImage? = nil
    @Published var selectedPhoto: PhotosPickerItem? = nil {
        didSet {
            Task {
                try await setImage(from: selectedPhoto)
            }
        }
    }
    
    init() {
        Task {
            try await fetchFotos()
        }
    }
    
    @MainActor
    func uploadPhoto(name: String) async throws {
        isLoaded = true
        
        guard let item = self.selectedPhoto else { return }
        
        guard let photoData = try await item.loadTransferable(type: Data.self) else { return }
        
        let photoInfo = try await PhotoUploader.uploaderPhoto(withData: photoData)
        
        guard let photoURL = photoInfo.photoURL else { return }
        
        try await Firestore.firestore().collection("photos").document().setData(["photoURL": photoURL, "name": name, "id": photoInfo.fileName])
        
        Task { try await fetchFotos() }
        
        clean()
    }
    
    func clean() {
        isLoaded = false
        self.selectedPhoto = nil
        self.selectedImage = nil
        self.name = ""
    }
    
    @MainActor
    func fetchFotos() async throws {
        let snapshot = try await Firestore.firestore().collection("photos").getDocuments()
        
        self.photos = snapshot.documents.compactMap({ try? $0.data(as: ImageC.self)})
    }
    
    func filterPhotos(_ locationId: String) -> [ImageC] {
        var filteredPhoto = [ImageC]()
        
        for photo in photos {
            if photo.photoURL.contains(locationId) {
                filteredPhoto.append(photo)
            }
        }
        
        return filteredPhoto
    }
    
    func filerPhoto(_ locationId: String) throws -> ImageC {
        for photo in photos {
            if photo.photoURL.contains(locationId) {
                return photo
            }
        }
        throw PhotosVMError.invalidId
    }
    
    @MainActor
    func setImage(from selection: PhotosPickerItem?) async throws {
        Task {
            do {
                let data = try await selection?.loadTransferable(type: Data.self)
                
                guard let data, let uiImage = UIImage(data: data) else {
                    throw URLError(.badServerResponse)
                }
                self.photo = nil
                self.name = ""
                self.selectedImage = uiImage
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func setPhoto(photo: ImageC) {
        self.photo = photo
        clean()
    }
    
    @MainActor
    func updatePhotoName(photo: ImageC, name: String) async throws {
        do {
            
            guard let documentId = photo.documentId else { return }
            try await Firestore.firestore().collection("photos").document(documentId).updateData(["photoURL": photo.photoURL, "name": name])
            
            Task { try await fetchFotos() }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @MainActor
    func save0rUpdate(name: String) async throws {
        if name.isEmpty {
            return
        }
        
        if let photo = self.photo {
           try await updatePhotoName(photo: photo, name: name)
            self.photo = nil
            self.name = ""
        } else {
            try await uploadPhoto(name: name)
            clean()
        }
    }
    
    @MainActor
    func deletePhoto() async throws {
        do {
            guard let photo = self.photo else { return }
            
            let storageRef = Storage.storage().reference().child("photos/location/photo/\(photo.id)")
            
            try  await storageRef.delete()
            
            guard let documentId = photo.documentId else { return }
            try await Firestore.firestore().collection("photos").document(documentId).delete()
            
            clean()
            self.photo = nil
            
            Task { try await fetchFotos() }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @MainActor
    func cansel() {
        self.photo = nil
        clean()
    }
}

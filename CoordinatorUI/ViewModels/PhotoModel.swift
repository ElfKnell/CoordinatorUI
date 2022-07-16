//
//  PhotoModel.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 03/07/2022.
//

import UIKit
import SwiftUI
import AVFoundation

enum PhotoOrCamera {
    case photo, camera
    
    enum PickerError: Error, LocalizedError {
        case unavailable
        case restricted
        case denied
        
        var errorDescription: String? {
            switch self {
            case .unavailable:
                return NSLocalizedString("There is no available camera on this devise.", comment: "")
            case .restricted:
                return NSLocalizedString("You are not allowed to access media capture devise.", comment: "")
            case .denied:
                return NSLocalizedString("You have explicitly denied permission for media capture. Please open permissions/Privacy/Camera and grant access for this application.", comment: "")
            }
        }
    }
    
    static func checkPermisions() throws {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            switch authStatus {
            case .restricted:
                throw PickerError.restricted
            case .denied:
                throw PickerError.denied
            default:
                break
            }
        } else {
            throw PickerError.unavailable
        }
    }
    
    struct CameraErroreType {
        let error: PhotoOrCamera.PickerError
        var message: String {
            error.localizedDescription
        }
        let button = Button("OK", role: .cancel) {}
    }
}

extension PhotoView {
    @MainActor class PhotoModel: ObservableObject {
        
        @Published var status = PhotoOrCamera.photo
        @Published var scale: CGFloat = 1
        @Published var isShovingPhotoPicker = false
        @Published var image: UIImage?     //UIImage(systemName: "photo.fill")!
        @Published var showCameraAlert = false
        @Published var cameraError: PhotoOrCamera.CameraErroreType?
        @Published var imageName: String = ""
        @Published var isEditing = false
        @Published var selectedImage: MyImage?
        @Published var myImages = [MyImage]()
        @Published var showFileAlert = false
        @Published var appError: MyImageError.ErrorType?
        
        init() {
            print(FileManager.documentsDirectory.path)
        }
        
        var buttonDisabled: Bool {
            imageName.isEmpty || image == nil
        }
        
        var deleteButtonIsHidden: Bool {
            isEditing || selectedImage == nil
        }
        
        func addPhoto(status: PhotoOrCamera) {
            self.status = status
            showPhotoPicker()
        }
        
        func reset() {
            imageName = ""
            image = nil
            selectedImage = nil
            isEditing = false
        }
        
        func showPhotoPicker() {
            do {
                if status == .camera {
                    try PhotoOrCamera.checkPermisions()
                }
                isShovingPhotoPicker = true
            } catch {
                showCameraAlert = true
                cameraError = PhotoOrCamera.CameraErroreType(error: error as! PhotoOrCamera.PickerError)
            }
        }
        
        func display(_ myImage: MyImage) {
            image = myImage.image
            imageName = myImage.name
            selectedImage = myImage
        }
        
        func updateSelected() {
            if let index = myImages.firstIndex(where: { $0.id == selectedImage?.id} ) {
                myImages[index].name = imageName
                saveMyImagesJSONFile()
                reset()
            }
        }
        
        func deleteSelected() {
            if let index = myImages.firstIndex(where: { $0.id == selectedImage?.id }) {
                myImages.remove(at: index)
                saveMyImagesJSONFile()
                reset()
            }
        }
        
        func addMyImage(_ name: String, image: UIImage) {
            
            let myImage = MyImage(name: name)
            do {
                try FileManager().saveImage("\(myImage.id)", image: image)
                myImages.append(myImage)
                saveMyImagesJSONFile()
            } catch {
                showFileAlert = true
                appError = MyImageError.ErrorType(error: error as! MyImageError)
            }
            reset()
        }
        
        func saveMyImagesJSONFile() {
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(myImages)
                let jsonString = String(decoding: data, as: UTF8.self)
                do {
                    try FileManager().saveDocument(contents: jsonString)
                } catch {
                    showFileAlert = true
                    appError = MyImageError.ErrorType(error: error as! MyImageError)
                }
            } catch {
                showFileAlert = true
                appError = MyImageError.ErrorType(error: .encodingError)
            }
        }
        
        func loadMyImageJSONFile() {
            do {
                let data = try FileManager().readDocument()
                do {
                    myImages = try JSONDecoder().decode([MyImage].self, from: data)
                } catch {
                    showFileAlert = true
                    appError = MyImageError.ErrorType(error: .decodingError)
                }
            } catch {
                showFileAlert = true
                appError = MyImageError.ErrorType(error: error as! MyImageError)
            }
        }
    }
}

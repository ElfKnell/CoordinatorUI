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
        @Published var image = UIImage(named: "logo")!
        @Published var images = [UIImage]()
        @Published var indexC = 0
        @Published var showCameraAlert = false
        @Published var cameraError: PhotoOrCamera.CameraErroreType?
        
        func addPhoto(status: PhotoOrCamera) {
            self.status = status
            showPhotoPicker()
            images.append(image)
            indexC += 1
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
    }
}

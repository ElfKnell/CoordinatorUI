//
//  PhotoModel.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 03/07/2022.
//

import UIKit
import SwiftUI

enum PhotoOrCamera {
    case photo, camera
    
    static func checkPermisions() -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            return true
        } else {
            return false
        }
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
        
        func addPhoto(status: PhotoOrCamera) {
            self.status = status
            showPhotoPicker()
            images.append(image)
            indexC += 1
        }
        
        func showPhotoPicker() {
            if status == .camera {
                if !PhotoOrCamera.checkPermisions() {
                    print("There is no camera on this device")
                    return
                }
            }
            isShovingPhotoPicker = true
        }
    }
}

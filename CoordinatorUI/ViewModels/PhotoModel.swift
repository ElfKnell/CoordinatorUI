//
//  PhotoModel.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 03/07/2022.
//

import UIKit

enum PhotoOrCamera {
    case photo, camera
}

extension PhotoView {
    @MainActor class PhotoModel: ObservableObject {
        
        @Published var status = PhotoOrCamera.photo
        @Published var scale: CGFloat = 1
        @Published var isShovingPhotoPicker = false
        @Published var image = UIImage(named: "logo")!
        @Published var images = [UIImage]()
        @Published var indexC = 0
    }
}

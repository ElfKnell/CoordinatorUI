//
//  CameraModel.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 21/10/2023.
//

import AVFoundation
import CoreImage
import Combine
import UIKit

final class CameraViewModel: ObservableObject {
    @Published var frame: CGImage?
    @Published var error: Error?
    static var photo: UIImage? = nil
    
    private let frameManager = FrameManager.shared
    private let cameraManager = CameraManager.shared
    private static var cancellable: AnyCancellable?

    
    //Since CIContexts are expensive to create,
    //its better to have it as private to reuse the context instead of recreating it every frame.
    private let context = CIContext()
    
    init() {
        setupSubscriptions()
    }
    
    func setupSubscriptions() {
       
        //Set frames Pipline
        frameManager.$current
            .receive(on: RunLoop.main)
            .compactMap { [weak self] buffer in

                guard let image = CGImage.create(from: buffer) else {
                  return nil
                }

                let ciImage = CIImage(cgImage: image)
                
                return self?.context.createCGImage(ciImage, from: ciImage.extent)
            }
            .assign(to: &$frame)
      
        
        //Set Errors pipLine
        cameraManager.$error
            .receive(on: RunLoop.main)
            .map { $0 }
            .assign(to: &$error)
        
    }
    
    
    static func take() {
            debugPrint("Clicked PhotoManager.take()")
        var cgImage: CGImage?
            cancellable = FrameManager.shared.$current.first().sink { receiveValue in
                guard receiveValue != nil else {
                    debugPrint("[W] PhotoManager.take: buffer returned nil")
                    return
                }

                let inputImage = CIImage(cvPixelBuffer: receiveValue!)
                let context = CIContext(options: nil)
                cgImage = context.createCGImage(inputImage, from: inputImage.extent)
            }
        guard cgImage != nil else {
            return
        }
        photo = UIImage(cgImage: cgImage!)
    }
}

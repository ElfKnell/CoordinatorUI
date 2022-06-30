//
//  PhotoView.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 28/06/2022.
//

import SwiftUI

struct PhotoView: View {
    @State private var scale: CGFloat = 1
    @State private var isShovingPhotoPicker = false
    @State private var image = UIImage(named: "logo")!
    
    var body: some View {
        VStack {
              Spacer()
              Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .zoomable(scale: $scale)
                .onTapGesture {
                    isShovingPhotoPicker = true
                }
            
              Spacer()
              HStack {
                Button("Reset") {
                  scale = 1
                }
                Spacer()
                Text("Zoom: \(String(format: "%.02f", scale * 100) )%")
              }
              .padding()
            }
        .sheet(isPresented: $isShovingPhotoPicker) {
            PhotoPicker(image: $image)
        }
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoView()
    }
}

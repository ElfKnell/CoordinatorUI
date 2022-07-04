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
    @State private var images = [UIImage]()

    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Section() {
                            if !images.isEmpty {
                                //ForEach(0..<images.count) { i in
                                    Image(uiImage: images[0])
                                        .resizable()
                                        .scaledToFit()
                                //}
 
                            } else {
                                Image(systemName: "photo.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .tag(4)
                                    .onTapGesture {
                                        image = UIImage(named: "logo")!
                                    }
                            }
                        }
                    }
                }
                .frame(height: 140)

                Spacer()
                
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .zoomable(scale: $scale)
                    .onTapGesture {
                        isShovingPhotoPicker = true
                        images.append(image)
                    }
                
                Spacer()
                
                HStack{
                    Spacer()
                    
                    Button {
                        print(images.count)
                    } label: {
                        Text("Camera")
                    }
                    
                    Spacer()
                    
                    Button {
                        isShovingPhotoPicker = true
                        images.append(image)
                    } label: {
                        Text("Photos")
                    }
                    
                    Spacer()
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
            .navigationBarHidden(true)
            .sheet(isPresented: $isShovingPhotoPicker) {
                PhotoPicker(image: $image)
            }
        }
        
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoView()
    }
}

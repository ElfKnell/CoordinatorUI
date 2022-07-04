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
    @State private var indexC = 0
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        
                            if !images.isEmpty {
                                
                                ForEach(0..<indexC, id:\.self) { index in
                                    Image(uiImage: images[index])
                                        .resizable()
                                        .scaledToFit()
                                }
 
                            } else {
                                Image(systemName: "photo.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .onTapGesture {
                                        image = UIImage(systemName: "photo.fill")!
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
//                    .onTapGesture {
//                        isShovingPhotoPicker = true
//                        images.append(image)
//                        indexC += 1
//                    }
                
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
                        indexC += 1
                        print(images)
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

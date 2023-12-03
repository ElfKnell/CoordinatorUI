//
//  BigPhotoView.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 09/10/2022.
//

import SwiftUI

struct BigPhotoView: View {
    
    var img: UIImage?
    var photoCloud: ImageC?
    var txt: String = "none"
    @State private var scalet: CGFloat = 0.7
    
    
    var body: some View {
        
        ZStack {
            
            BackgroundView()
            
            if (img != nil) || (photoCloud != nil) {
                ZStack(alignment: .bottom) {
                    
                    if let photoCloud = photoCloud {
                        AsyncImage(url: URL(string: photoCloud.photoURL)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .ignoresSafeArea()
                                .zoomable(scale: $scalet)
                        } placeholder: {
                            ProgressView()
                        }
                    } else if let img = img {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                            .zoomable(scale: $scalet)
                    }
                    
                    HStack {
                        Button {
                            scalet = 1
                        } label: {
                            ButtonLabel(symbolLabel: "gobackward", label: "Reset")
                        }
                        .padding(.horizontal)
                        
                        Text("Zoom: \(String(format: "%.02f", scalet * 100) )%")
                            .foregroundColor(.white)
                            .frame(height: 40)
                            .padding(.horizontal)
                            .background(Color.blue)
                            .cornerRadius(15)
                            .padding(.horizontal)
                    }
                }
            } else {
                Text(txt)
            }
        }
    }
}

struct BigPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BigPhotoView(img: nil, photoCloud: nil)
        }
    }
}

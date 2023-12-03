//
//  AsyncPhotoView.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 12/11/2023.
//

import SwiftUI

struct AsyncPhotoView: View {
    
    var photo: ImageC?
    
    var body: some View {
            
        if let photo = photo {
            AsyncImage(url: URL(string: photo.photoURL)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(radius: 5)
            } placeholder: {
                ProgressView()
            }
        }
    }
}

#Preview {
    AsyncPhotoView(photo: nil)
}

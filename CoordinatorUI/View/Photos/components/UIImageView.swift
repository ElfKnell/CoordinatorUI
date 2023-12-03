//
//  SwiftUIView.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 26/11/2023.
//

import SwiftUI

struct UIImageView: View {
    var uiImage: UIImage
    
    var body: some View {
        Image(uiImage: uiImage)
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(radius: 5)
    }
}

#Preview {
    UIImageView(uiImage: UIImage.actions)
}

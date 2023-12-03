//
//  ButtonLabelView.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 13/08/2023.
//

import SwiftUI

struct ButtonLabelView: View {
    
    var title: String
    var widthButton: CGFloat
    
    var body: some View {
        Text(title)
            .bold()
            .frame(width: widthButton, height: 50)
            .font(.system(size: 30, design: .serif))
            .background(
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(.linearGradient(colors: [.red, .yellow], startPoint: .bottomTrailing, endPoint: .topLeading))
            )
            .foregroundColor(.black)
    }
}

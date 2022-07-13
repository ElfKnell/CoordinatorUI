//
//  ButtonLabel.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 12/07/2022.
//

import SwiftUI

struct ButtonLabel: View {
    
    let symbolLabel: String
    let label: String
    
    var body: some View {
        HStack {
            Image(systemName: symbolLabel)
            Text(label)
        }
        .font(.headline)
        .padding()
        .frame(height: 40)
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(15)
    }
}

struct ButtonLabel_Previews: PreviewProvider {
    static var previews: some View {
        ButtonLabel(symbolLabel: "camera", label: "Camera")
    }
}

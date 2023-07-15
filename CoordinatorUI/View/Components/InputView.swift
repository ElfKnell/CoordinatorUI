//
//  InputView.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 12/07/2023.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .textFieldStyle(.plain)
                .font(.system(size: 20, design: .serif))
            
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .textFieldStyle(.plain)
                    .font(.system(size: 20, design: .serif))
                    .frame(width: 300)
            } else {
                TextField(placeholder, text: $text)
                    .textFieldStyle(.plain)
                    .font(.system(size: 20, design: .serif))
                    .frame(width: 300)
            }
            
            Rectangle()
                .frame(width: 350, height: 1)
        }
        
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(text: .constant(""), title: "Email", placeholder: "name@example.com")
    }
}

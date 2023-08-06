//
//  SettingsRowView.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 15/07/2023.
//

import SwiftUI

struct SettingsRowView: View {
    let nameImage: String
    let title: String
    let tintColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: nameImage)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)
            
            Text(title)
                .font(.subheadline)
            
        }
        
    }
}

struct SettingsRowView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRowView(nameImage: "gear", title: "Version", tintColor: .gray)
    }
}

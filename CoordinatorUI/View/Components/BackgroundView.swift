//
//  BackgroundView.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 13/08/2023.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 30, style: .continuous)
            .foregroundStyle(.linearGradient(colors: [.blue, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
            .rotationEffect(.degrees(137))
            .ignoresSafeArea()
    }
}

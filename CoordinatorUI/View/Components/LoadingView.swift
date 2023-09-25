//
//  LoadingView.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 04/09/2023.
//

import SwiftUI

struct LoadingView: View {
    
    @State var isLoading = false
    
    var body: some View {
        ZStack {
            Color(.blue).edgesIgnoringSafeArea(.all)
            
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, dash: [4, 20]))
                .frame(width: 130, height: 130, alignment: .center)
                .foregroundColor(.yellow)
                .onAppear() {
                    withAnimation(Animation.linear(duration: 3.0).repeatForever(autoreverses: false)) {
                        isLoading.toggle()
                    }
                }
                .rotationEffect(Angle(degrees: isLoading ? 0 : 360))
            
            Text("Loading...")
                .foregroundColor(.yellow)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}

//
//  FaceLoginView.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 13/08/2023.
//

import SwiftUI

struct FaceLoginView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {

            ZStack {
                
                BackgroundView()
                
                VStack {
                    Spacer()
                    
                    Text("Locked")
                        .font(.system(size: 50,weight: .bold, design: .serif))
                        .offset(x: -30)
                    
                    Spacer()
                    
                    Button {
                        viewModel.authenticate()
                    } label: {
                        
                        ButtonLabelView(title: "Unlock places", widthButton: 250)
                       
                    }
                    
                    Spacer()
                }
            }
    }
}

struct FaceLoginView_Previews: PreviewProvider {
    static var previews: some View {
        FaceLoginView()
    }
}

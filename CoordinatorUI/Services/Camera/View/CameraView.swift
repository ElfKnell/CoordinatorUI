//
//  CameraView.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 22/10/2023.
//

import SwiftUI

struct CameraView: View {
    
    @StateObject var viewModel = CameraViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            CameraFrameView(image: viewModel.frame)
                .ignoresSafeArea()
            
            ErrorView(error: viewModel.error)
            
            filters
        }
        .onAppear {
            CameraManager.shared.controllSession(start: true)
        }
        .onDisappear {
            CameraManager.shared.controllSession(start: false)
        }
    }
}

extension CameraView {
    var filters: some View {
        VStack {
            Spacer()
            HStack {
                if viewModel.frame == nil {
                    Button {
                        CameraViewModel.take()
                        dismiss()
                    } label: {
                        Image(systemName: "camera.fill")
                    }
                    .font(.largeTitle)
                    .buttonStyle(.borderless)
                    .controlSize(.large)
                    .tint(.accentColor)
                    .padding(10)
                }
            }
            .padding()
        }
    }
}


#Preview {
    CameraView()
}

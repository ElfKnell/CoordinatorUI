//
//  ContentView.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 23/06/2022.
//

import SwiftUI
import MapKit
import LocalAuthentication

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isUnlocked {
                ZStack {
                    Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations) { location in
                        MapAnnotation(coordinate: location.coordinate) {
                            VStack(spacing: 0) {
                                  Image(systemName: "mappin.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.red)
                                  
                                  Image(systemName: "arrowtriangle.down.fill")
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .offset(x: 0, y: -5)
                                
                                Text(location.name)
                                    .fixedSize()
                                }
                            .onTapGesture {
                                viewModel.selectedPlace = location
                            }
                        }
                    }
                        .ignoresSafeArea()
                    Circle()
                        .fill(.blue)
                        .opacity(0.3)
                        .frame(width: 30, height: 30)
                    VStack {
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            Button {
                                for i in viewModel.locations {
                                    print(i.id)
                                }
                            } label: {
                                Image(systemName: "plus")
                            }
                            
                            Button {
                                viewModel.addLocation()
                            } label: {
                                Image(systemName: "plus")
                            }
                            .padding()
                            .background(.black.opacity(0.75))
                            .foregroundColor(.white)
                            .font(.title)
                            .clipShape(Circle())
                            .padding(.trailing)
                        }
                    }
                }
                .sheet(item: $viewModel.selectedPlace) { place in
                    EditView(location: place) { newLocation in
                        viewModel.updateLocation(location: newLocation)
                    }
                }
                
            } else {
                Text("Locked")
            }
        }
        .onAppear(perform: authenticate)
        
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need unlock your data."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    viewModel.isUnlocked = true
                } else {
                    viewModel.isUnlocked = false
                    print(authenticationError?.localizedDescription ?? "Fatal error")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

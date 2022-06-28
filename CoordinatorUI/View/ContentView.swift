//
//  ContentView.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 23/06/2022.
//

import SwiftUI
import MapKit


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
                        HStack {
                            
                            Spacer()
                            
                            TextField("Latitude", text: $viewModel.latitude)
                                .font(.title)
                                .textFieldStyle(.roundedBorder)
                            
                            Spacer()
                            
                            TextField("Longitude", text: $viewModel.longitude)
                                .font(.title)
                                .textFieldStyle(.roundedBorder)
                            
                            Spacer()
                            
                            Button {
                                viewModel.changeLocation()
                            } label: {
                                Image(systemName: "paperplane.fill")
                            }
                            .padding()
                            .background(.black.opacity(0.75))
                            .foregroundColor(.white)
                            .font(.title)
                            .clipShape(Circle())
                            
                            Spacer()
                        }
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
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
                VStack {
                    Spacer()
                    
                    Text("Locked")
                    
                    Spacer()
                    
                    Button("Unlock places") {
                        viewModel.authenticate()
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    
                    Spacer()
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

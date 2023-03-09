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
    private var locationEdit = LocationEdit()
    
    private var region = RegionEdit()
    
    @Environment(\.scenePhase) private var scenePhase
    
    @EnvironmentObject var locationFetcher: LocationFetcher
    
    @State private var mapRegion = RegionEdit.mapRegion
    
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    
    @State private var locations: [Location] = []
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isUnlocked {
                    ZStack {
                        Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
                            MapAnnotation(coordinate: location.coordinate) {
                                    
                                NavigationLink {
                                    
                                    EditView(location: location)
                                    
                                } label: {
                                    
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
                                
                                TextField("Latitude", text: $latitude)
                                    .font(.title)
                                    .textFieldStyle(.roundedBorder)
                                
                                Spacer()
                                
                                TextField("Longitude", text: $longitude)
                                    .font(.title)
                                    .textFieldStyle(.roundedBorder)
                                
                                Spacer()
                                
                                Button {
                                    guard let t = region.changeRegion(latitude: latitude, longitude: longitude) else { return }
                                    
                                    mapRegion = t
                                    
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
                                    
                                    locationEdit.addLocation(mapRegion: mapRegion)
                                    
                                    locations = locationEdit.loc()
                                    
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
                    .task {
                        locations = locationEdit.loc()
                        
                        let sRegin = StartRegion(locationFetcher.coordinateRegion)
                        
                        mapRegion = sRegin.startRegion
                    }
                    .onChange(of: scenePhase) { phase in
                        if phase == .inactive {
                            region.saveRegion(Region.decoder(mapRegion))
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
}
    
struct ContentView_Previews: PreviewProvider {
    static let locationFetcher = LocationFetcher()
    
    static var previews: some View {
        ContentView()
            .environmentObject(locationFetcher)
    }
}

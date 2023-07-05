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
    
    private var regionEdit = RegionEdit()
    
    @State private var textErrorRegion = ""
    
    @Environment(\.scenePhase) private var scenePhase
    
    @EnvironmentObject var locationFetcher: LocationFetcher
    
    @State private var mapRegion = RegionEdit.mapRegion
    
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    
    @State private var isErrorRegion = false
    
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
                                    
                                    do {
                                        mapRegion = try regionEdit.changeRegion(latitude: latitude, longitude: longitude)
                                    } catch {
                                        isErrorRegion = true
                                        
                                        textErrorRegion = error.localizedDescription
                                    }
                                    
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
                            regionEdit.saveRegion(Region.decoder(mapRegion))
                        }
                    }
                    .alert("Error Region", isPresented: $isErrorRegion) {
                        
                    } message: {
                        Text(textErrorRegion)
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

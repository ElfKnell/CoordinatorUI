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
    
    @State private var isUnlocked = true
    
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50.0, longitude: -70.0), span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20))
    
    @State private var locations = [Location]()
    
    @State private var selectedPlace: Location?
    
    var body: some View {
        VStack {
            if isUnlocked {
                ZStack {
                    Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
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
                                selectedPlace = location
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
                                for i in locations {
                                    print(i.id)
                                }
                            } label: {
                                Image(systemName: "plus")
                            }
                            
                            Button {
                                let newLocation = Location(id: UUID(), name: "New location", description: "unknown", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
                                locations.append(newLocation)
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
                .sheet(item: $selectedPlace) { place in
                    EditView(location: place) { newLocation in
                        if let index = locations.firstIndex(of: place) {
                            locations[index] = newLocation
                        }
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
                    isUnlocked = true
                } else {
                    isUnlocked = false
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

//
//  ContentView.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 23/06/2022.
//

import SwiftUI
import MapKit
import LocalAuthentication

//let chats = [Chat(title: "he", subtitle: "How are you?"),
//             Chat(title: "fine", subtitle: "I'm fine"),
//             Chat(title: "You", subtitle: "and how are you?")]

struct ContentView: View {
    
    @State private var isUnlocked = true
    
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50.0, longitude: -70.0), span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20))
    
    @State private var locations = [Location]()
    
    var body: some View {
        VStack {
            if isUnlocked {
                ZStack {
                    Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
                        MapMarker(coordinate: location.coordinate)
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
                
            } else {
                Text("Locked")
            }
        }
        .onAppear(perform: authenticate)
        
        
//        List(chats) {
//            chat in
//            Text("\(chat.id) \(chat.title) \(chat.subtitle)")
//        }
//            .padding()
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

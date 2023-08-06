//
//  CoordinatorUIApp.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 23/06/2022.
//

import SwiftUI
import Firebase

@main
struct CoordinatorUIApp: App {
    @StateObject var locationFetcher = LocationFetcher()
    @StateObject var authViewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            StartView()
                .onAppear {
                    UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutUnsatisfiable")
                    
                    locationFetcher.start()
                }
                .environmentObject(locationFetcher)
                .environmentObject(authViewModel)
        }
    }
}

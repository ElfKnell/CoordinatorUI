//
//  CoordinatorUIApp.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 23/06/2022.
//

import SwiftUI

@main
struct CoordinatorUIApp: App {
    
    @StateObject var locationFetcher = LocationFetcher()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutUnsatisfiable")
                    
                    locationFetcher.start()
                }
                .environmentObject(locationFetcher)
        }
    }
}

//
//  CoordinatorUIApp.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 23/06/2022.
//

import SwiftUI

@main
struct CoordinatorUIApp: App {
    @StateObject private var locationEdit = LocationEdit()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationEdit)
                .onAppear {
                    UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutUnsatisfiable")
                }
        }
    }
}

//
//  ContentView-ModelView.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 26/06/2022.
//

import Foundation
import LocalAuthentication

class ViewModel: ObservableObject {
    @Published var isUnlocked = false
        
    func authenticate() {
        let context = LAContext()
        var error: NSError?
            
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock your places."
                
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    Task { @MainActor in
                        self.isUnlocked = true
                    }
                } else {
                    Task { @MainActor in
                        self.isUnlocked = false
                        print(authenticationError?.localizedDescription ?? "Fatal error")
                    }
                }
            }
        }
    }
}

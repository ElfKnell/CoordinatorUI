//
//  StartView.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 01/08/2023.
//

import SwiftUI

struct StartView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Group {
            if authViewModel.userSession != nil {
                
                if authViewModel.isValid {
                    MenuView()
                } else {
                    AuditUserView()
                }
            } else {
                LoginView()
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}

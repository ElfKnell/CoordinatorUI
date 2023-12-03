//
//  AuditUserView.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 13/08/2023.
//

import SwiftUI

struct AuditUserView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        
        if viewModel.isUnlocked {
            MenuView()
        } else {
            FaceLoginView()
        }
    }
}

struct AuditUserView_Previews: PreviewProvider {
    static var previews: some View {
        AuditUserView()
    }
}

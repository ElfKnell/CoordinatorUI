//
//  ProfileView.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 15/07/2023.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel : AuthViewModel
    
    var body: some View {
        if let user = authViewModel.currentUser {
            List {
                Section {
                    HStack {
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color.gray)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading) {
                            Text(user.fullname)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.top)
                            
                            Text(user.email)
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal)
                    }
                }
                
                Section("General") {
                    HStack {
                        SettingsRowView(nameImage: "gear", title: "Version", tintColor: Color(.systemGray))
                        
                        Spacer()
                        
                        Text("1.0.0")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                Section("Account") {
                    Button {
                        authViewModel.signOut()
                    } label: {
                        SettingsRowView(nameImage: "arrow.left.circle.fill", title: "Sign out", tintColor: .red)
                    }
                    
                    Button {
                        Task {
                            await authViewModel.deleteAccount()
                        }
                    } label: {
                        SettingsRowView(nameImage: "xmark.circle.fill", title: "Delete account", tintColor: .red)
                    }
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

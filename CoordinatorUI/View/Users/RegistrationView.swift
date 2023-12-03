//
//  RegistrationView.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 13/07/2023.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var name = ""
    @State private var password = ""
    @State private var cPassword = ""
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                BackgroundView()
                
                VStack {
                    
                    Spacer()
                    
                    Text("Registration")
                        .font(.system(size: 45,weight: .bold, design: .serif))
                        .offset(x: -53, y: -110)
                    
                    InputView(text: $email, title: "Email", placeholder: "name@example.com")
                        .autocapitalization(.none)
                        .offset(x: -20, y: -45)
                    
                    InputView(text: $name, title: "Full name", placeholder: "Name")
                        .offset(x: -15, y: -30)
                    
                    InputView(text: $password, title: "Password", placeholder: "password", isSecureField: true)
                        .offset(x: 15, y: -15)
                    
                    ZStack(alignment: .trailing) {
                        InputView(text: $cPassword, title: "Confirm password", placeholder: "confirm password", isSecureField: true)
                            .offset(x: 25)
                        
                        if !password.isEmpty && !cPassword.isEmpty {
                            if password == cPassword {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemGreen))
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemRed))
                            }
                        }
                    }
                    
                    Button {
                        Task {
                            try await viewModel.createUser(withEmail: email, password: password, fullname: name)
                        }
                    } label: {
                        
                        ButtonLabelView(title: "Sign up", widthButton: 170)
                            .offset(x: 40, y: 30)
                        
                    }
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0 : 0.5)
                    
                    Spacer()
                    
                    HStack {
                        Text("Already have an account?")
                            .font(.system(size: 25, design: .serif))
                        
                        Button {
                            dismiss()
                        } label: {
                            Text("Login")
                                .bold()
                                .font(.system(size: 27, design: .serif))
                                .foregroundColor(.green)
                        }
                    }
                }
            }
        }
    }
}

extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && cPassword == password
        && !name.isEmpty
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}

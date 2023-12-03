//
//  LoginView.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 11/07/2023.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                BackgroundView()
                
                VStack {
                    Spacer()
                    
                    Text("Welcome")
                        .font(.system(size: 50,weight: .bold, design: .serif))
                        .offset(x: -50, y: -130)
                    
                    InputView(text: $email, title: "Email", placeholder: "name@example.com")
                        .autocapitalization(.none)
                        .offset(x: -15, y: -50)
                    
                    InputView(text: $password, title: "Password", placeholder: "password", isSecureField: true)
                        .offset(y: -35)
                    
                    NavigationLink {
                        
                    } label: {
                        Text("Forgot password?")
                            .foregroundColor(.green)
                            .font(.system(size: 20, design: .serif))
                            .offset(x:100, y: -10)
                    }

                    Button {
                        Task {
                            try await authViewModel.signIn(withEmail: email, password: password)
                        }
                    } label: {
                        
                        ButtonLabelView(title: "Sign in", widthButton: 170)
                       
                    }
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0 : 0.5)
                    
                    Spacer()
                    
                    HStack {
                        Text("Don't have an account?")
                            .font(.system(size: 25, design: .serif))
                        
                        NavigationLink {
                            RegistrationView()
                                .navigationBarBackButtonHidden(true)
                        } label: {
                            Text("Sign up")
                                .bold()
                                .font(.system(size: 27, design: .serif))
                                .foregroundColor(.green)
                        }
                    }
                    .padding(.bottom)
                }
            }
            .ignoresSafeArea()
        }
    }
}

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

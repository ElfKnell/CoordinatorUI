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
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .foregroundStyle(.linearGradient(colors: [.blue, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 1500, height: 390)
                    .rotationEffect(.degrees(-110))
                
                VStack {
                    Spacer()
                    
                    Text("Welcome")
                        .font(.system(size: 50,weight: .bold, design: .serif))
                        .offset(x: -50, y: -130)
                    
                    InputView(text: $email, title: "Email", placeholder: "name@example.com")
                        .autocapitalization(.none)
                        .offset(x: -20, y: -50)
                    
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
                        
                    } label: {
                        Text("Sign in")
                            .bold()
                            .frame(width: 170, height: 50)
                            .font(.system(size: 30, design: .serif))
                            .background(
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(.linearGradient(colors: [.red, .yellow], startPoint: .bottomTrailing, endPoint: .topLeading))
                            )
                            .foregroundColor(.black)
                    }
                    
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

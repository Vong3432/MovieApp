//
//  AuthView.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 18/05/2022.
//

import SwiftUI

struct AuthView: View {
    enum Field: Hashable {
        case username
        case password
    }
    
    @StateObject private var vm: AuthViewModel
    @FocusState private var focusedField: Field?
    
    init(authService: MovieDBAuthProtocol) {
        _vm = StateObject(wrappedValue: AuthViewModel(authService: authService))
    }
    
    private var disabledBtn: Bool {
        vm.username.trimmingCharacters(in: .whitespaces).isEmpty || vm.password.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 40) {
                    CloseFullScreenButton()
                    decorate
                    formContent
                    Spacer()
                    signInBtn
                }
                .padding()
                .padding(.bottom)
                .frame(maxWidth: .infinity, alignment: .leading)
                .customTint(Color.theme.primary)
            }
        }
        .onAppear {
            // Delay for 0.5 otherwise focusField won't work.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                focusedField = .username
            }
        }
    }
    
    private func signInBtnTapped() {
        if vm.username.isEmpty {
            focusedField = .username
        } else if vm.password.isEmpty {
            focusedField = .password
        } else {
            Task { await vm.handleSignIn() }
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            AuthView(authService: AppState().authService)
                .environmentObject(AppState())
            .preferredColorScheme(.dark)
        }
    }
}

extension AuthView {
       
    private var decorate: some View {
        ZStack {
            GeometryReader { geo in
                Circle()
                    .fill(Color.theme.primary)
                    .scaleEffect(1.1)
                    .frame(width: geo.size.width / 3, height: geo.size.height / 1.5)
                    .opacity(0.1)
                    .position(x: 0, y: geo.size.height * 1)
                
                Circle()
                    .fill(Color.theme.primary)
                    .scaleEffect(2)
                    .frame(width: geo.size.width / 2, height: geo.size.height / 1.5)
                    .opacity(0.3)
                    .position(x: geo.size.width / 1.5, y: geo.size.height / 2)
            }
            
            Image("auth")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: 200)
        }
    }
    
    private var formContent: some View {
        VStack(alignment: .leading) {
            Text("Sign In")
                .font(.largeTitle)
                .fontWeight(.bold)
                .accessibilityIdentifier("SignInPageTitle")
            
            VStack(spacing: 20) {
                TextField("Username", text: $vm.username)
                    .focused($focusedField, equals: .username)
                    .textFieldStyle(.plain)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    .accessibilityIdentifier("UsernameField")
                
                SecureField("Password", text: $vm.password)
                    .focused($focusedField, equals: .password)
                    .textFieldStyle(.plain)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    .accessibilityIdentifier("PasswordField")
                
                if let errorMsg = vm.errorMsg {
                    Text(errorMsg)
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(nil)
                        .accessibilityIdentifier("FormErrorLabel")
                }
            }
        }
    }
    
    private var signInBtn: some View {
        Button {
            signInBtnTapped()
        } label: {
            if vm.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
            } else {
                Text("Sign In")
                    .frame(maxWidth: .infinity)
                    .buttonFilled()
            }
        }
        .accessibilityIdentifier("SignInBtn")
        .disabled(vm.isLoading || disabledBtn)
    }
}

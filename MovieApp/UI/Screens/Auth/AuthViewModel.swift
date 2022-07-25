//
//  AuthViewModel.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 18/05/2022.
//

import Foundation

extension AuthView {
    class AuthViewModel: ObservableObject {
        @Published var errorMsg: String? = nil
        @Published var isLoading = false
        @Published var username: String = ""
        @Published var password: String = ""
        private let authService: MovieDBAuthProtocol
        
        init(authService: MovieDBAuthProtocol) {
            self.authService = authService
        }
        
        func handleSignIn() async {
            DispatchQueue.main.async {
                self.isLoading = true
                self.errorMsg = nil
            }
             
            do {
                try await authService.login(username: username, password: password)
            }
            catch let error {
                errorMsg = error.localizedDescription
            }
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
}

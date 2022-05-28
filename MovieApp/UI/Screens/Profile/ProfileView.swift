//
//  ProfileView.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 12/03/2022.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var appState: AppState
    @State private var isAuthenticated: Bool = false
    
    var body: some View {
        ZStack {
            Color.theme.background
            
            VStack {
                Text("Profile")
                if isAuthenticated {
                    Button("Logout") {
                        logout()
                    }
                } else {
                    Button("Login") {
                        login()
                    }
                }
            }
        }
        .onReceive(appState.authService.isAuthenticatedPublisher, perform: { isAuthenticated in
            self.isAuthenticated = isAuthenticated
        })
        .preferredColorScheme(.dark)
    }
    
    private func login() {
        Task {
            appState.showSignInScreen()
        }
    }
    
    private func logout() {
        Task {
            try? await appState.authService.logout("")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ProfileView()
                .environmentObject(AppState())
        }
    }
}

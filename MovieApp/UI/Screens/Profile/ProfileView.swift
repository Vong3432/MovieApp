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
    @Environment(\.locale) private var locale
    
    var body: some View {
        ZStack {
            Color.theme.background
            
            List {
                Section(content: {
                    Picker("language", selection: $appState.currentLocale) {
                        
                        ForEach(appState.availableIdentifiers, id: \.self) { identifier in
                            Text(identifier)
                                .tag(identifier)
                        }
                    }.pickerStyle(.automatic)
                }, header: {
                    Text("profile_preference_label")
                })
                
                if isAuthenticated {
                    Button("sign_out") {
                        logout()
                    }
                    .accessibilityIdentifier("SignOutBtn")
                } else {
                    Button("sign_in") {
                        login()
                    }
                    .accessibilityIdentifier("SignInBtn")
                }

            }
            .listStyle(.grouped)
            
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
        Group {
            NavigationView {
                ProfileView()
                    .environmentObject(AppState())
                    .navigationTitle("profile_tab_title")
                    .environment(\.locale, .init(identifier: "en"))
            }.previewDisplayName("ENG")
            
            NavigationView {
                ProfileView()
                    .environmentObject(AppState())
                    .navigationTitle("profile_tab_title")
                    .environment(\.locale, .init(identifier: "zh-Hans"))
            }.previewDisplayName("ZH-hans")
        }
    }
}

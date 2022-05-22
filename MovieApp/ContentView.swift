//
//  ContentView.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 12/03/2022.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var appState: AppState

    var body: some View {
        TabView {
            NavigationView {
                HomeView()
                    .navigationTitle("Movies")
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            
            NavigationView {
                FavoriteView(
                    authService: appState.authService,
                    favoriteService: appState.favoriteService
                ).navigationTitle("Favorites")
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Image(systemName: "heart.fill")
                Text("Favorite")
            }
            
            NavigationView {
                ProfileView()
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
        }
        .fullScreenCover(isPresented: $appState.showingSignInScreen) {
            AuthView(authService: appState.authService)
        }
        .onReceive(appState.authService.isAuthenticatedPublisher) { isAuthenticated in
            if isAuthenticated == true && appState.showingSignInScreen {
                appState.closeSignInScreen()
            }
        }
        .preferredColorScheme(.dark)
        .customTint(Color.theme.primary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppState())
    }
}

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
                    .navigationTitle("home_tab_title")
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Image(systemName: "house.fill")
                Text("home_tab_title")
                    .accessibilityIdentifier("Home")
            }
            
            NavigationView {
                ExploreView()
                    .navigationTitle("explore_tab_title")
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("explore_tab_title")
                    .accessibilityIdentifier("Explore")
            }
            
            NavigationView {
                FavoriteView(
                    authService: appState.authService,
                    favoriteService: appState.favoriteService
                ).navigationTitle("favorite_tab_title")
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Image(systemName: "heart.fill")
                Text("favorite_tab_title")
                    .accessibilityIdentifier("Favorite")
            }
            
            NavigationView {
                ProfileView()
                    .navigationTitle("profile_tab_title")
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Image(systemName: "person.fill")
                Text("profile_tab_title")
                    .accessibilityIdentifier("Profile")
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
        Group {
            ContentView()
                .environmentObject(AppState())
                .previewDisplayName("ENG")
                .environment(\.locale, .init(identifier: "en"))
            ContentView()
                .environmentObject(AppState())
                .previewDisplayName("zh-CN")
                .environment(\.locale, .init(identifier: "zh-Hans"))
        }
    }
}

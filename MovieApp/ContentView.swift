//
//  ContentView.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 12/03/2022.
//

import SwiftUI

struct ContentView: View {
    
    init() {

    }
    
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
                FavoriteView()
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
        .preferredColorScheme(.dark)
        .customTint(Color.theme.primary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

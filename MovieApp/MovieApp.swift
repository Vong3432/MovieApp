//
//  MovieAppApp.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 12/03/2022.
//

import SwiftUI

@main
struct MovieApp: App {
    @StateObject private var appState = AppState()
    @AppStorage("firstLaunch") var firstLaunched: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if firstLaunched {
                WalkthroughView(firstLaunched: $firstLaunched)
                    .environmentObject(appState)
            } else {
                ContentView()
                    .environmentObject(appState)
            }
        }
    }
}

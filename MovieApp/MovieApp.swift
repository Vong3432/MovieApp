//
//  MovieAppApp.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 12/03/2022.
//

import SwiftUI

@main
struct MovieApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState: AppState
    @AppStorage("firstLaunch") var firstLaunched: Bool = true
    
    init() {
        _appState = StateObject(wrappedValue: AppState())
    }
    
    var body: some Scene {
        WindowGroup {
            if firstLaunched {
                WalkthroughView(firstLaunched: $firstLaunched)
                    .environmentObject(appState)
                    .environment(\.locale, .init(identifier: appState.currentLocale))
            } else {
                ContentView()
                    .environmentObject(appState)
                    .environment(\.locale, .init(identifier: appState.currentLocale))
            }
        }.onChange(of: appState.currentLocale) { locale in
            appState.saveLocaleSetting(locale)
        }
    }
}

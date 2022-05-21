//
//  AppState.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 17/05/2022.
//

import Foundation
import SwiftUI

final class AppState: ObservableObject {
    @Published var authService: MovieDBAuthProtocol = MovieDBAuthService()
    @Published var showingSignInScreen: Bool = false
    
    init() {
        
    }
    
    func showSignInScreen() {
        showingSignInScreen = true
    }
    
    func closeSignInScreen() {
        showingSignInScreen = false
    }
}

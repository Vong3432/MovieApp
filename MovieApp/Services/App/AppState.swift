//
//  AppState.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 17/05/2022.
//

import Foundation
import Combine
import SwiftUI

final class AppState: ObservableObject {
    let availableIdentifiers = ["en", "zh-Hans"]
    
    @Published var favoriteService: FavoritedDataServiceProtocol = FavoritedDataService()
//    @Published var paymentService = PaymentService()
    @Published var authService: MovieDBAuthProtocol = MovieDBAuthService()
    @Published var showingSignInScreen: Bool = false
    @Published var showingSearchScreen: Bool = false
    @Published var showingToast: Bool = false
    @Published var currentLocale: String = "en"
    
    private var anyCancellable: AnyCancellable? = nil
    
    init() {
        if let locale = UserDefaults.standard.string(forKey: .localePreference) {
            // if user has set their preferenced languages
            self.currentLocale = locale
        } else  {
            // otherwise, use "en"
            self.currentLocale = availableIdentifiers[0]
        }
        
//        anyCancellable = paymentService.objectWillChange.sink { [weak self] (_) in
//            self?.objectWillChange.send()
//        }
    }
    
    func showSignInScreen() {
        showingSignInScreen = true
    }
    
    func closeSignInScreen() {
        showingSignInScreen = false
    }
    
    func showSearchScreen() {
        showingSearchScreen = true
    }
    
    func closeSearchScreen() {
        showingSearchScreen = false
    }
    
    func showToast() {
        showingToast = true
    }
    
    /// This function should be called in "MovieApp.swift" only.
    func saveLocaleSetting(_ locale: String) {
        UserDefaults.standard.set(locale, forKey: .localePreference)
    }
}

//
//  FavoriteViewModel.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 22/05/2022.
//

import Foundation
import Combine

extension FavoriteView {
    class FavoriteViewModel: ObservableObject {
        @Published var isLoading = false
        @Published var favoriteList = [Movie]()
        
        let authService: MovieDBAuthProtocol
        let dataService: FavoritedDataServiceProtocol
        private var cancellables = Set<AnyCancellable>()
        
        init(authService: MovieDBAuthProtocol, dataService: FavoritedDataServiceProtocol) {
            self.authService = authService
            self.dataService = dataService
            
            subscribe()
        }
        
        private func subscribe() {
            dataService.favoritedMoviesPublisher
                .sink { [weak self] favoriteList in
                    self?.favoriteList = favoriteList
                }
                .store(in: &cancellables)
        }
        
        func loadFavorites() {
            guard let account = authService.account, let sessionId = authService.getSessionId() else { return }
            Task {
                isLoading = true
                let _ = try? await dataService.getFavoritedMovies(from: account.id, sessionId: sessionId)
                isLoading = false
            }
        }
    }
}

//
//  FavoriteViewModel.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 22/05/2022.
//

import Foundation
import Combine
import Algorithms

extension FavoriteView {
    class FavoriteViewModel: ObservableObject {
        @Published var isFetchingMore = false
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
                    guard let self = self else { return }
                    let combined = chain(self.favoriteList, favoriteList)
                    self.favoriteList = combined.uniqued(on: { $0.id })
                }
                .store(in: &cancellables)
        }
        
        func loadFavorites(nextPage: Bool? = false) async {
            guard let account = authService.account,
                let sessionId = authService.getSessionId(),
                isLoading == false else { return }
            
            // Don't show spinner for infinite pagination
            if nextPage == false {
                isLoading = true
            }
            let _ = try? await dataService.getFavoritedMovies(from: account.id, sessionId: sessionId, nextPage: nextPage)
            isLoading = false
            isFetchingMore = false
        }
        
        func refresh() async {
            clear()
            isLoading = false
            await loadFavorites()
        }
        
        func loadMore() async {
            isFetchingMore = true
            
            // Wait for 1s to let users know we are loading more data
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            await loadFavorites(nextPage: true)
        }
        
        func clear() {
            /// clear local favoriteList so that we can "completely" clear favoriteList because there is a ``chain()`` in ``self.subscribe()``.
            favoriteList = []
            isFetchingMore = false
            dataService.reset()
            dataService.clear()
        }
        
        func remove(_ movie: Movie) {
            guard let account = authService.account,
                let sessionId = authService.getSessionId() else { return }
            
            Task {
                try? await dataService.markFavorite(for: movie, as: false, from: account.id, sessionId: sessionId)
            }
        }
    }
}

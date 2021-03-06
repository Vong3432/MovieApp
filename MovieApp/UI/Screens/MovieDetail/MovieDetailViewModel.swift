//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 13/03/2022.
//

import Foundation
import Combine

extension MovieDetailView {
    class MovieDetailViewModel: ObservableObject {
        @Published private(set) var isLoading = false
        @Published private(set) var currentMovie: Movie
        @Published private(set) var videos = [Video]()
        @Published private(set) var crew: Crew?
        @Published private(set) var top10Cast = [Cast]()
        @Published private(set) var reviews = [Movie.Review]()
        @Published private(set) var similarMovies = [Movie]()
        @Published private(set) var isFavorited = false
        
        @Published private(set) var toastMsg: String? = nil
        
        private var currentReviewPage = 1
        private var totalReviewPages = 0
        private(set) var videosUrl: String
        private(set) var crewUrl: String
        private(set) var reviewUrl: String
        private(set) var similarMovieUrl: String
        private(set) var detailUrl: String
        
        private var dataService: MovieDataServiceProtocol? = nil
        private var favoriteService: FavoritedDataServiceProtocol
        let authService: MovieDBAuthProtocol
        
        private var cancellables = Set<AnyCancellable>()
        
        init(movie: Movie, dataService: MovieDataServiceProtocol, authService: MovieDBAuthProtocol, favoriteService: FavoritedDataServiceProtocol) {
            self.currentMovie = movie
            self.dataService = dataService
            self.authService = authService
            self.favoriteService = favoriteService
            videosUrl = APIEndpoints.apiBaseUrl + "/movie/\(movie.id)/videos"
            crewUrl = APIEndpoints.apiBaseUrl + "/movie/\(movie.id)/credits"
            reviewUrl = APIEndpoints.apiBaseUrl + "/movie/\(movie.id)/reviews"
            similarMovieUrl = APIEndpoints.apiBaseUrl + "/movie/\(movie.id)/similar"
            detailUrl = APIEndpoints.apiBaseUrl + "/movie/\(movie.id)"
            
            clearToast()
            fetchMovieInfo(movie)
        }
        
        deinit {
            print("DEINIT")
        }
        
        func fetchMovieInfo(_ movie: Movie) {
            isLoading = true
            isFavorited = false
            
            // reset paginations
            totalReviewPages = 0
            currentReviewPage = 1
            
            videosUrl = APIEndpoints.apiBaseUrl + "/movie/\(movie.id)/videos"
            crewUrl = APIEndpoints.apiBaseUrl + "/movie/\(movie.id)/credits"
            reviewUrl = APIEndpoints.apiBaseUrl + "/movie/\(movie.id)/reviews"
            similarMovieUrl = APIEndpoints.apiBaseUrl + "/movie/\(movie.id)/similar"
            detailUrl = APIEndpoints.apiBaseUrl + "/movie/\(movie.id)"
            
            getFavoriteStatus()
            loadDetail()
            loadVideos()
            loadCrew()
            loadReviews()
            loadSimilarMovies()
            
            // hide loading after 1.5s to ensure most of the things are loaded on-time rather than
            // making the detail page show "sudden-appear" contents
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.isLoading = false
            }
        }
        
        func loadDetail() {
            dataService?.downloadData(from: detailUrl, as: Movie.self)
                .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] returnedData in
                    DispatchQueue.main.async {
                        self?.currentMovie = returnedData
                    }
                }
                .store(in: &cancellables)
        }
        
        func loadVideos() {
            dataService?.downloadData(from: videosUrl, as: MovieDBResponse<Video>.self)
                .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] returnedData in
                    DispatchQueue.main.async {
                        self?.videos = returnedData.results ?? []
                    }
                }
                .store(in: &cancellables)
        }
        
        func loadCrew() {
            dataService?.downloadData(from: crewUrl, as: Crew.self)
                .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] (returnedData) in
                    DispatchQueue.main.async {
                        self?.crew = returnedData
                        guard let wrappedCast = returnedData.cast else { return }
                        self?.top10Cast = Array(wrappedCast.prefix(10))
                    }
                }
                .store(in: &cancellables)
        }
        
        func loadReviews(nextPage: Bool? = false) {
            var url = reviewUrl
            
            // If we want to load more reviews
            if nextPage == true {
                // if there is more to fetch,
                // then we will continue to fetch next page
                if currentReviewPage < totalReviewPages {
                    currentReviewPage = currentReviewPage + 1
                    url += "?page=\(currentReviewPage)"
                } else {
                    // we reach the final page, do nothing.
                    return
                }
            }
            
            dataService?.downloadData(from: url, as: MovieDBResponse<Movie.Review>.self)
                .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] (returnedData) in
                    DispatchQueue.main.async {
                        self?.reviews = returnedData.results ?? []
                        self?.totalReviewPages = returnedData.totalPages ?? 0
                    }
                }
                .store(in: &cancellables)
        }
        
        func loadSimilarMovies() {
            dataService?.downloadData(from: similarMovieUrl, as: MovieDBResponse.self)
                .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] (returnedData) in
                    DispatchQueue.main.async {
                        self?.similarMovies = returnedData.results ?? []
                    }
                }
                .store(in: &cancellables)
        }
        
        func changeMovie(_ movie: Movie) {
            currentMovie = movie
            fetchMovieInfo(movie)
        }
        
        func getFavoriteStatus() {
            guard let account = authService.account, let sessionId = authService.getSessionId() else { return }
            
            Task {
                do {
                    // TODO: Quite slow here
                    let favorited = try await favoriteService.getFavoriteStatus(for: currentMovie, from: account.id, sessionId: sessionId)
                    DispatchQueue.main.async {
                        self.isFavorited = favorited
                    }
                } catch {
                    setToastMsg(error.localizedDescription)
                }
            }
        }
        
        func favorite(showToast: (() -> ())? = nil) {
            guard let account = authService.account, let sessionId = authService.getSessionId() else { return }
            
            Task {
                do {
                    // if currentMovie is favorited
                    // then, we will assume user want to "unfavourite"
                    // else, we assume user want to "favorite" currentMovie.
                    clearToast()
                    let favoriteText = isFavorited ? "Remove this from your favorite list successfully" : "mark_favorite_success"
                    try await favoriteService.markFavorite(for: currentMovie, as: !isFavorited, from: account.id, sessionId: sessionId)
                    
                    setToastMsg(favoriteText)
                    showToast?()
                    
                    DispatchQueue.main.async {
                        self.isFavorited = !self.isFavorited
                    }
//                    getFavoriteStatus()
                } catch {
                    setToastMsg(error.localizedDescription)
                }
            }
        }
        
        private func setToastMsg(_ toastMsg: String) {
            DispatchQueue.main.async {
                self.toastMsg = toastMsg
            }
        }
        
        private func clearToast() {
            DispatchQueue.main.async {
                self.toastMsg = nil
            }
        }
    }
}

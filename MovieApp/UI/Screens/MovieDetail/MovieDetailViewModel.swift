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
        
        private var currentReviewPage = 1
        private var totalReviewPages = 0
        private(set) var videosUrl: String
        private(set) var crewUrl: String
        private(set) var reviewUrl: String
        private(set) var similarMovieUrl: String
        
        private var dataService: MovieDataServiceProtocol
        
        private var cancellables = Set<AnyCancellable>()
        
        init(movie: Movie, dataService: MovieDataServiceProtocol) {
            self.currentMovie = movie
            self.dataService = dataService
            videosUrl = APIEndpoints.apiBaseUrl + "/movie/\(movie.id!)/videos"
            crewUrl = APIEndpoints.apiBaseUrl + "/movie/\(movie.id!)/credits"
            reviewUrl = APIEndpoints.apiBaseUrl + "/movie/\(movie.id!)/reviews"
            similarMovieUrl = APIEndpoints.apiBaseUrl + "/movie/\(movie.id!)/similar"
            
            fetchMovieInfo(movie)
        }
        
        func fetchMovieInfo(_ movie: Movie) {
            isLoading = true
            
            // reset paginations
            totalReviewPages = 0
            currentReviewPage = 1
            
            videosUrl = APIEndpoints.apiBaseUrl + "/movie/\(movie.id!)/videos"
            crewUrl = APIEndpoints.apiBaseUrl + "/movie/\(movie.id!)/credits"
            reviewUrl = APIEndpoints.apiBaseUrl + "/movie/\(movie.id!)/reviews"
            similarMovieUrl = APIEndpoints.apiBaseUrl + "/movie/\(movie.id!)/similar"
            
            loadVideos()
            loadCrew()
            loadReviews()
            loadSimilarMovies()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.isLoading = false
            }
        }
        
        func loadVideos() {
            dataService.downloadData(from: videosUrl, as: MovieDBResponse.self)
                .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] returnedData in
                    self?.videos = returnedData.results ?? []
                }
                .store(in: &cancellables)
        }
        
        func loadCrew() {
            dataService.downloadData(from: crewUrl, as: Crew.self)
                .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] (returnedData) in
                    self?.crew = returnedData
                    
                    guard let wrappedCast = returnedData.cast else { return }
                    self?.top10Cast = Array(wrappedCast.prefix(10))
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
            
            dataService.downloadData(from: url, as: MovieDBResponse<Movie.Review>.self)
                .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] (returnedData) in
                    self?.reviews = returnedData.results ?? []
                    self?.totalReviewPages = returnedData.totalPages ?? 0
                }
                .store(in: &cancellables)
        }
        
        func loadSimilarMovies() {
            dataService.downloadData(from: similarMovieUrl, as: MovieDBResponse.self)
                .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] (returnedData) in
                    self?.similarMovies = returnedData.results ?? []
                }
                .store(in: &cancellables)
        }
        
        func changeMovie(_ movie: Movie) {
            currentMovie = movie
            fetchMovieInfo(movie)
        }
    }
}

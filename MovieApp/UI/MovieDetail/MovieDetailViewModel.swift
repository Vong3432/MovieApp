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
        
        private var dataService: MovieDataServiceProtocol
        
        private var cancellables = Set<AnyCancellable>()
        
        init(movie: Movie, dataService: MovieDataServiceProtocol) {
            self.currentMovie = movie
            self.dataService = dataService
            
            fetchMovieInfo(movie)
        }
        
        func fetchMovieInfo(_ movie: Movie) {
            let videosUrl = .apiBaseUrl + "/movie/\(movie.id!)/videos"
            let crewUrl = .apiBaseUrl + "/movie/\(movie.id!)/credits"
            let reviewUrl = .apiBaseUrl + "/movie/\(movie.id!)/reviews"
            let similarMovieUrl = .apiBaseUrl + "/movie/\(movie.id!)/similar"
            
            isLoading = true
            
            loadVideos(videosUrl)
            loadCrew(crewUrl)
            loadReviews(reviewUrl)
            loadSimilarMovies(similarMovieUrl)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.isLoading = false
            }
        }
        
        func loadVideos(_ videosUrl: String) {
            dataService.downloadData(from: videosUrl, as: MovieDBResponse.self)
                .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] returnedData in
                    self?.videos = returnedData.results ?? []
                }
                .store(in: &cancellables)
        }
        
        func loadCrew(_ crewUrl: String) {
            dataService.downloadData(from: crewUrl, as: Crew.self)
                .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] (returnedData) in
                    self?.crew = returnedData
                    
                    guard let wrappedCast = returnedData.cast else { return }
                    self?.top10Cast = Array(wrappedCast.prefix(10))
                }
                .store(in: &cancellables)
        }
        
        func loadReviews(_ reviewUrl: String) {
            dataService.downloadData(from: reviewUrl, as: MovieDBResponse.self)
                .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] (returnedData) in
                    self?.reviews = returnedData.results ?? []
                }
                .store(in: &cancellables)
        }
        
        func loadSimilarMovies(_ similarMovieUrl: String) {
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

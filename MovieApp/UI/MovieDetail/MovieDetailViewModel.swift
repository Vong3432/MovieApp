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
        @Published private(set) var videos = [Video]()
        @Published private(set) var crew: Crew?
        @Published private(set) var top10Cast = [Cast]()
        @Published private(set) var reviews = [Movie.Review]()
        
        private let videosUrl: String
        private let crewUrl: String
        private let reviewUrl: String
        private let dataService: MovieDataServiceProtocol
        
        private var cancellables = Set<AnyCancellable>()
        
        init(movie: Movie, dataService: MovieDataServiceProtocol) {
            self.videosUrl = .apiBaseUrl + "/movie/\(movie.id!)/videos"
            self.crewUrl = .apiBaseUrl + "/movie/\(movie.id!)/credits"
            self.reviewUrl = .apiBaseUrl + "/movie/\(movie.id!)/reviews"
            
            self.dataService = dataService
            
            loadVideos()
            loadCrew()
            loadReviews()
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
        
        func loadReviews() {
            dataService.downloadData(from: reviewUrl, as: MovieDBResponse.self)
                .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] (returnedData) in
                    self?.reviews = returnedData.results ?? []
                }
                .store(in: &cancellables)
        }
    }
}

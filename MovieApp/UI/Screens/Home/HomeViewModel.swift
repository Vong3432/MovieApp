//
//  HomeViewModel.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 12/03/2022.
//


import Foundation
import SwiftUI
import Combine

extension HomeView {
    class HomeViewModel: ObservableObject {
        
        @Published private(set) var isLoading = false
        @Published private(set) var topRatedMovies = [Movie]()
        @Published private(set) var upcomingMovies = [Movie]()
        
        private var cancellables = Set<AnyCancellable>()
        private let dataService: MovieDataServiceProtocol
        
        init(dataService: MovieDataServiceProtocol) {
            self.dataService = dataService
            loadData()
        }
        
        func loadData() {
            isLoading = true
            fetchTopRateMovies()
            fetchUpcomingMovies()
        }
        
        private func fetchTopRateMovies() {
            dataService.downloadData(from: APIEndpoints.topRatedMoviesUrl.url, as: MovieDBResponse<Movie>.self)
                .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] returnedData in
                    self?.topRatedMovies = returnedData.results ?? []
                    self?.isLoading = false
                }
                .store(in: &cancellables)
        }
        
        private func fetchUpcomingMovies() {
            dataService.downloadData(from: APIEndpoints.upcomingMoviesUrl.url, as: MovieDBResponse<Movie>.self)
                .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] returnedData in
                    self?.upcomingMovies = returnedData.results ?? []
                }
                .store(in: &cancellables)
        }
        
    }
}


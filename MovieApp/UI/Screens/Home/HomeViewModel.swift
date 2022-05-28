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

        private let topRatedUrl = APIEndpoints.apiBaseUrl + "/movie/top_rated"
        private let upcomingUrl = APIEndpoints.apiBaseUrl + "/movie/upcoming"
        
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
            dataService.downloadData(from: topRatedUrl, as: MovieDBResponse.self)
                .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] returnedData in
                    self?.topRatedMovies = returnedData.results ?? []
                }
                .store(in: &cancellables)
        }
        
        private func fetchUpcomingMovies() {
            dataService.downloadData(from: upcomingUrl, as: MovieDBResponse<Movie>.self)
                .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] returnedData in
                    self?.upcomingMovies = returnedData.results ?? []
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.isLoading = false
                    }
                }
                .store(in: &cancellables)
        }
        
    }
}


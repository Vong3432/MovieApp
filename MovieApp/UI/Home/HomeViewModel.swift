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
        
        @Published var topRatedMovies = [Movie]()
        @Published var upcomingMovies = [Movie]()
        @Published var isLoading = false

        private let topRatedUrl = .apiBaseUrl + "/movie/top_rated"
        private let upcomingUrl = .apiBaseUrl + "/movie/upcoming"
        
        private var cancellables = Set<AnyCancellable>()
        private let dataService = MovieDataService()
//        private let topRatedDataService = MovieDataService(url: .apiBaseUrl + "/movie/top_rated")
//        private let upComingDataService = MovieDataService(url: .apiBaseUrl + "/movie/upcoming")
//        private let topRatedDataService = MovieDataService(url: .apiBaseUrl + "/movie/popular")
        
        init() {
            loadData()
        }
        
        private func loadData() {
            fetchTopRateMovies()
            fetchUpcomingMovies()
        }
        
        private func fetchTopRateMovies() {
            dataService.downloadData(from: topRatedUrl)
                .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] returnedData in
                    self?.topRatedMovies = returnedData.results ?? []
                }
                .store(in: &cancellables)
        }
        
        private func fetchUpcomingMovies() {
            dataService.downloadData(from: upcomingUrl)
                .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] returnedData in
                    self?.upcomingMovies = returnedData.results ?? []
                }
                .store(in: &cancellables)
        }
        
    }
}


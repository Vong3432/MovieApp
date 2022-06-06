//
//  ExploreViewModel.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 02/06/2022.
//

import Foundation
import Algorithms
import Combine
import SwiftUI

extension ExploreView {
    class ExploreViewModel: ObservableObject, Paginable {
        var currentPage: Int = PaginableValues.defaultCurrentPage
        var totalPages: Int = PaginableValues.defaultCurrentPage
        
        @Published var regions = [Region.Result]()
        @Published var region: Region.Result = Region.Result.mockRegionResult
        
        @Published var isLoading = false
        @Published var isFetchingMore = false
        @Published var movies: [Movie] = []
        @Published var searchText = ""
        
        private let dataService: MovieDataServiceProtocol
        private var cancellables = Set<AnyCancellable>()
        
        init(dataService: MovieDataServiceProtocol) {
            self.dataService = dataService
            
            subscribe()
        }
        
        private func subscribe() {
            $searchText
                .debounce(for: 0.8, scheduler: RunLoop.main)
                .sink { text in
                    self.clear()
                    self.fetchMovies()
                }
                .store(in: &cancellables)
        }
        
        func loadRegions() async {
            // only fetch regions for once when needed
            if regions.isEmpty {
                let response = try? await dataService.downloadData(from: APIEndpoints.getAvailableRegions.url, as: Region.self, queries: nil)
                
                regions = response?.results ?? []
                
                if regions.isNotEmpty {
                    region = regions[0]
                }
            }
        }
        
        func fetchMovies(nextPage: Bool? = false) {
            guard isLoading == false else { return }
            
            // Don't show spinner for infinite pagination
            if nextPage == false {
                isLoading = true
            }
            
            Task {
                let queryItems = [
                    URLQueryItem(name: "query", value: searchText),
                    URLQueryItem(name: "region", value: region.iso31661)
                ]
                
                var url = APIEndpoints.searchMovies.url
                
                if nextPage == true {
                    if shouldFetchNextPageUrl(url: &url) == false {
                        DispatchQueue.main.async {
                            self.isFetchingMore = false
                        }
                        return
                    }
                }
                
                let response = try? await dataService.downloadData(from: url, as: MovieDBResponse<Movie>.self, queries: queryItems)
                
                currentPage = response?.page ?? PaginableValues.defaultCurrentPage
                totalPages = response?.totalPages ?? PaginableValues.defaultTotalPages
                
                let combined = chain(movies, response?.results ?? [])
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.isFetchingMore = false
                    self.movies = combined.uniqued(on: { $0.id })
                }
            }
        }
        
        func clearText() {
            searchText = ""
        }
        
        func clear() {
            reset()
            movies = []
        }
        
        func refresh() {
            clear()
            fetchMovies()
        }
        
        func loadMore() async {
            isFetchingMore = true
            
            // Wait for 1s to let users know we are loading more data
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            fetchMovies(nextPage: true)
        }
    }
}

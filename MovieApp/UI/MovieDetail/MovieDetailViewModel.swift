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
        
        private let videosUrl: String
        private let dataService = MovieDataService()
        
        private var cancellables = Set<AnyCancellable>()
        
        init(movie: Movie) {
            self.videosUrl = .apiBaseUrl + "/movie/\(movie.id!)/videos"
            
            loadVideos()
        }
        
        private func loadVideos() {
            dataService.downloadData(from: videosUrl)
                .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] returnedData in
                    self?.videos = returnedData.results ?? []
                }
                .store(in: &cancellables)
        }
    }
}

//
//  MovieDataService.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 12/03/2022.
//

import Foundation
import Combine

class MovieDataService: ObservableObject {
    
    @Published var page: Int? = nil
    @Published var movies = [Movie]()
    
    private var cancellables = Set<AnyCancellable>()
    
//    init(url: String) {
//        downloadData(from: url)
//    }
    
    func downloadData(from url: String) -> AnyPublisher<MovieList, Error> {
        guard let url = URL(string: url) else { return Fail(error: NSError(domain: "Fail to download", code: 500, userInfo: nil)).eraseToAnyPublisher() }

        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return NetworkingManager
            .download(url: url)
            .decode(type: MovieList.self, decoder: decoder)
            .eraseToAnyPublisher()
//            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] returnedMovieList in
//                self?.page = returnedMovieList.page
//                self?.movies = returnedMovieList.results ?? []
//            }
//            .store(in: &cancellables)
    }
}

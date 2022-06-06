//
//  WebService.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 06/06/2022.
//

import Foundation
import UIKit
import Combine

struct WMovie {
    let poster: UIImage
    let title: String
    let rating: Double
}

class WebService {
    private static var cancellables = Set<AnyCancellable>()
    
    static func fetchFirstMovie(completion: @escaping (WMovie?) -> ()) {
        
        // Fetch popular movies because the latest movies API is not stable (some required data are null)
        // Hence, we just fetch popular movies and get the first movie on the widget instead.
        guard let url = URL(string: APIEndpoints.popularMoviesUrl.url) else { return }
        let newUrl = getURLAfterConfig(url: url, query: nil)
        var wMovie: WMovie? = nil
        
        URLSession.shared.dataTaskPublisher(for: newUrl)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { try handleURLResposne(output: $0, url: newUrl) }
            .decode(type: MovieDBResponse<Movie>.self, decoder: MovieDBAPIResponseParser.jsonDecoder)
            .sink(receiveCompletion: handleCompletion(completion:)) { returnedMovies in
                guard let movie = returnedMovies.results?.first else {
                    print("ERR")
                    completion(nil)
                    return
                }
                
                URLSession.shared.dataTask(with: URL(string: movie.wrappedPosterPath)!) { imgdata, imgresponse, imgerror in
                    guard let imgdata = imgdata else {
                        print("ERR")
                        completion(nil)
                        return
                    }

                    if let poster = UIImage(data: imgdata) {
                        wMovie = WMovie(poster: poster, title: movie.wrappedTitle, rating: movie.wrappedVoteAverage)
                    } else {
                        print("ERR")
                        wMovie = WMovie(poster: UIImage(named: "placeholder")!, title: movie.wrappedTitle, rating: movie.wrappedVoteAverage)
                    }
                    
                    completion(wMovie)
                }.resume()
                
            }
            .store(in: &cancellables)

    }
    
    static func handleURLResposne(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
                  
                  if let errorResponse = MovieDBAPIResponseParser.getErrorResponse(output.data) {
                      throw errorResponse
                  }
                  
                  throw URLError(.badServerResponse)
              }
        return output.data
    }
    
    static func getURLAfterConfig(url: URL, query: [URLQueryItem]? = nil) -> URL {
        let defaultQueryItems = [
            URLQueryItem(name: "api_key", value: Keys.apiToken)
        ]
        
        let queryItems = (query ?? []) + defaultQueryItems
        let newUrl = url.appending(queryItems)
        
        return newUrl!
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription) // human readable error
            break
        }
    }
}

//
//  MovieDataService.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 12/03/2022.
//

import Foundation
import Combine

protocol MovieDataServiceProtocol {
    func downloadData<T>(from url: String, as: T.Type) -> AnyPublisher<T, Error> where T: Codable
    func downloadData<T>(from url: String, as: T.Type, queries: [URLQueryItem]?) async throws -> T where T : Codable
}


enum MovieDataServiceError: LocalizedError {
    case apiError(_ msg: String?)
    
    var errorDescription: String? {
        switch self {
        case .apiError(let msg):
            return msg ?? "Unable to proceed"
        }
    }
}

class MovieDataService: MovieDataServiceProtocol {
    /// This method fetches list from API and returns result as AnyPublisher.
    ///
    /// The reasons that we don't create and store the results into a variable is because there are many APIEndPoints will return same ``T`` result.
    ///
    /// For instance: Fetching favorited movie list, popular or latest movie list will all returns ``T``. It would be weird to create  variables for every category of movies.
    ///
    /// Hence, instead of storing into variables, we just shift that responsibilities to the ViewModels that use this service, returning the results/error, and let them handle accordingly.
    func downloadData<T>(from url: String, as: T.Type) -> AnyPublisher<T, Error> where T: Codable {
        guard let url = URL(string: url) else { return Fail(error: NSError(domain: "Fail to download", code: 500, userInfo: nil)).eraseToAnyPublisher() }
        return NetworkingManager
            .download(url: url)
            .decode(type: T.self, decoder: MovieDBAPIResponseParser.jsonDecoder)
            .eraseToAnyPublisher()
    }
    
    func downloadData<T>(from url: String, as: T.Type, queries: [URLQueryItem]? = nil) async throws -> T where T: Codable {
        guard let url = URL(string: url) else { throw MovieDataServiceError.apiError("URL incorrect") }
        
        guard let data = try? await NetworkingManager.download(url: url, query: queries),
              let decoded: T = try? MovieDBAPIResponseParser.decode(data)
        else { throw MovieDataServiceError.apiError("Unable to decode") }
        return decoded
    }
}

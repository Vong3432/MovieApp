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
    func getFavoriteStatus(for movie: Movie, from: Int, sessionId: String) async throws -> Data
    func markFavorite(for movie: Movie, as: Bool, from: Int, sessionId: String) async throws -> Void
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
    func downloadData<T>(from url: String, as: T.Type) -> AnyPublisher<T, Error> where T: Codable {
        guard let url = URL(string: url) else { return Fail(error: NSError(domain: "Fail to download", code: 500, userInfo: nil)).eraseToAnyPublisher() }

        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return NetworkingManager
            .download(url: url)
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func getFavoriteStatus(for movie: Movie, from accountId: Int, sessionId: String) async throws -> Data {
        guard let url = URL(string: APIEndpoints.getFavoriteMovies(accountId: "\(accountId)").url) else {
            throw MovieDataServiceError.apiError("URL Error")
        }
        let queryItems = [URLQueryItem(name: "session_id", value: sessionId)]
    
        let data = try await NetworkingManager.download(url: url, query: queryItems)
        return data
    }
    
    func markFavorite(for movie: Movie, as favourite: Bool, from accountId: Int, sessionId: String) async throws {
        guard let url = URL(string: APIEndpoints.markFavorite(id: "\(accountId)").url) else { return }
        let body = MarkFavoriteRequestBody(mediaType: FavoriteType.movie.text, mediaId: movie.id, favorite: favourite)
        let queryItems = [URLQueryItem(name: "session_id", value: sessionId)]
        
        let encoded = try MovieDBAPIResponseParser.encode(body)
        let _ = try await NetworkingManager.post(url: url, body: encoded, query: queryItems)
    }
}

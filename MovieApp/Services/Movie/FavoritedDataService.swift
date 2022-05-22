//
//  FavoritedDataService.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 22/05/2022.
//

import Foundation

protocol FavoritedDataServiceProtocol {
    var favoritedMovies: [Movie] { get }
    var favoritedMoviesPublisher: Published<[Movie]>.Publisher { get }
    var favoritedMoviesPublished: Published<[Movie]> { get }
    
    func markFavorite(for movie: Movie, as: Bool, from: Int, sessionId: String) async throws -> Void
    func getFavoritedMovies(from: Int, sessionId: String) async throws -> [Movie]
    func getFavoriteStatus(for movie: Movie, from: Int, sessionId: String) async throws -> Bool
}


enum FavoritedDataServiceError: LocalizedError {
    case apiError(_ msg: String?)
    
    var errorDescription: String? {
        switch self {
        case .apiError(let msg):
            return msg ?? "Unable to proceed"
        }
    }
}

class FavoritedDataService: FavoritedDataServiceProtocol {
    @Published var favoritedMovies = [Movie]()
    var favoritedMoviesPublished: Published<[Movie]> { _favoritedMovies }
    var favoritedMoviesPublisher: Published<[Movie]>.Publisher { $favoritedMovies }
    
    func getFavoriteStatus(for movie: Movie, from accountId: Int, sessionId: String) async throws -> Bool {
        let _ = try await getFavoritedMovies(from: accountId, sessionId: sessionId)
        let idx = favoritedMovies.firstIndex(where: { $0 == movie })
        
        if idx == nil {
            return false
        } else {
            return true
        }
    }
    
    func getFavoritedMovies(from accountId: Int, sessionId: String) async throws -> [Movie] {
        guard let url = URL(string: APIEndpoints.getFavoriteMovies(accountId: "\(accountId)").url) else {
            throw MovieDataServiceError.apiError("URL Error")
        }
        let queryItems = [URLQueryItem(name: "session_id", value: sessionId)]
    
        let data = try await NetworkingManager.download(url: url, query: queryItems)
        let response: MovieDBResponse<Movie> = try MovieDBAPIResponseParser.decode(data)
        let movies = response.results ?? []
        favoritedMovies = movies
        
        return movies
    }
    
    func markFavorite(for movie: Movie, as favourite: Bool, from accountId: Int, sessionId: String) async throws {
        guard let url = URL(string: APIEndpoints.markFavorite(id: "\(accountId)").url) else { return }
        let body = MarkFavoriteRequestBody(mediaType: FavoriteType.movie.text, mediaId: movie.id, favorite: favourite)
        let queryItems = [URLQueryItem(name: "session_id", value: sessionId)]
        
        let encoded = try MovieDBAPIResponseParser.encode(body)
        let _ = try await NetworkingManager.post(url: url, body: encoded, query: queryItems)
    }
}

//
//  FavoritedDataService.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 22/05/2022.
//

import Foundation

protocol FavoritedDataServiceProtocol: Paginable {
    var favoritedMovies: [Movie] { get }
    var favoritedMoviesPublisher: Published<[Movie]>.Publisher { get }
    var favoritedMoviesPublished: Published<[Movie]> { get }
    
    func markFavorite(for movie: Movie, as: Bool, from: Int, sessionId: String) async throws -> Void
    func getFavoritedMovies(from: Int, sessionId: String, nextPage: Bool?) async throws -> [Movie]
    func getFavoriteStatus(for movie: Movie, from: Int, sessionId: String) async throws -> Bool
    func clear() -> Void
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

class FavoritedDataService: FavoritedDataServiceProtocol, Paginable {
    var currentPage: Int = PaginableValues.defaultCurrentPage
    var totalPages: Int = PaginableValues.defaultTotalPages
    
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
    
    func getFavoritedMovies(from accountId: Int, sessionId: String, nextPage: Bool? = false) async throws -> [Movie] {
        var apiUrl = APIEndpoints.getFavoriteMovies(accountId: "\(accountId)").url
        
        // If we want to load more reviews
        if nextPage == true {
            if shouldFetchNextPageUrl(url: &apiUrl) == false {
                return favoritedMovies
            }
        }
        
        guard let url = URL(string: apiUrl) else {
            throw MovieDataServiceError.apiError("URL Error")
        }
        let queryItems = [
            URLQueryItem(name: "session_id", value: sessionId),
            URLQueryItem(name: "sort_by", value: "created_at.desc")
        ]
    
        let data = try await NetworkingManager.download(url: url, query: queryItems)
        let response: MovieDBResponse<Movie> = try MovieDBAPIResponseParser.decode(data)
        let movies = response.results ?? []
        
        currentPage = response.page ?? PaginableValues.defaultCurrentPage
        totalPages = response.totalPages ?? PaginableValues.defaultTotalPages
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
    
    func clear() {
        favoritedMovies = []
    }
}

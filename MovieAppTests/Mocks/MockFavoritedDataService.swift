//
//  MockFavoritedDataService.swift
//  MovieAppTests
//
//  Created by Vong Nyuksoon on 26/05/2022.
//

import Foundation
@testable import MovieApp

final class MockFavoritedDataServiceFail: FavoritedDataServiceProtocol {
    @Published var favoritedMovies: [Movie] = []
    var favoritedMoviesPublisher: Published<[Movie]>.Publisher { $favoritedMovies }
    var favoritedMoviesPublished: Published<[Movie]> { _favoritedMovies }
    
    var currentPage: Int = PaginableValues.defaultCurrentPage
    var totalPages: Int = PaginableValues.defaultTotalPages
    
    func markFavorite(for movie: Movie, as: Bool, from: Int, sessionId: String) async throws {
        throw APIError(statusMessage: "Error", success: false, statusCode: 500)
    }
    
    func getFavoritedMovies(from: Int, sessionId: String, nextPage: Bool?) async throws -> [Movie] {
        throw APIError(statusMessage: "Error", success: false, statusCode: 500)
    }
    
    func getFavoriteStatus(for movie: Movie, from: Int, sessionId: String) async throws -> Bool {
        throw APIError(statusMessage: "Error", success: false, statusCode: 500)
    }
    
    func clear() {
        
    }
}

final class MockFavoritedDataService: FavoritedDataServiceProtocol {
    @Published var favoritedMovies: [Movie] = []
    var favoritedMoviesPublisher: Published<[Movie]>.Publisher { $favoritedMovies }
    var favoritedMoviesPublished: Published<[Movie]> { _favoritedMovies }
    
    var currentPage: Int = PaginableValues.defaultCurrentPage
    var totalPages: Int = PaginableValues.defaultTotalPages
    
    func markFavorite(for movie: Movie, as: Bool, from: Int, sessionId: String) async throws {
        if let idx = favoritedMovies.firstIndex(of: movie) {
            favoritedMovies.remove(at: idx)
        } else {
            favoritedMovies.insert(movie, at: 0)
        }
        return
    }
    
    func getFavoritedMovies(from: Int, sessionId: String, nextPage: Bool?) async throws -> [Movie] {
        if nextPage == true {
            // simulate fetching more data
            for i in 21..<41 {
                let mocked = Movie.fakedMovie
                var m = Movie(posterPath: mocked.posterPath, adult: mocked.adult, overview: mocked.overview, releaseDate: mocked.releaseDate, genreIDS: mocked.genreIDS, id: i, originalTitle: mocked.originalTitle, originalLanguage: mocked.originalLanguage, title: mocked.title, backdropPath: mocked.backdropPath, popularity: mocked.popularity, voteCount: mocked.voteCount, video: mocked.video, voteAverage: mocked.voteAverage)
                favoritedMovies.append(m)
            }
        } else {
            for i in 0..<21 {
                let mocked = Movie.fakedMovie
                var m = Movie(posterPath: mocked.posterPath, adult: mocked.adult, overview: mocked.overview, releaseDate: mocked.releaseDate, genreIDS: mocked.genreIDS, id: i, originalTitle: mocked.originalTitle, originalLanguage: mocked.originalLanguage, title: mocked.title, backdropPath: mocked.backdropPath, popularity: mocked.popularity, voteCount: mocked.voteCount, video: mocked.video, voteAverage: mocked.voteAverage)
                favoritedMovies.append(m)
            }
        }
        
        return favoritedMovies
    }
    
    func getFavoriteStatus(for movie: Movie, from: Int, sessionId: String) async throws -> Bool {
        let matched = favoritedMovies.first { $0 == movie }
        
        return matched == nil ? false : true
    }
    
    func clear() {
        favoritedMovies = []
    }
}

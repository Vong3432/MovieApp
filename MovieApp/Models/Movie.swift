//
//  Movie.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 12/03/2022.
//
/**
 API URL: https://api.themoviedb.org/3/movie/top_rated?api_key=API_KEY&language=en-US&page=1
 
 JSON Result:
 {
 "page": 1,
 "results": [
 {
 "poster_path": "/9O7gLzmreU0nGkIB6K3BsJbzvNv.jpg",
 "adult": false,
 "overview": "Framed in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison, where he puts his accounting skills to work for an amoral warden. During his long stretch in prison, Dufresne comes to be admired by the other inmates -- including an older prisoner named Red -- for his integrity and unquenchable sense of hope.",
 "release_date": "1994-09-10",
 "genre_ids": [
 18,
 80
 ],
 "id": 278,
 "original_title": "The Shawshank Redemption",
 "original_language": "en",
 "title": "The Shawshank Redemption",
 "backdrop_path": "/xBKGJQsAIeweesB79KC89FpBrVr.jpg",
 "popularity": 6.741296,
 "vote_count": 5238,
 "video": false,
 "vote_average": 8.32
 }
 ]
 */

import Foundation

// MARK: - MovieList
struct MovieDBResponse<T>: Codable where T: Codable {
    let page: Int?
    let results: [T]?
    
    let totalResults, totalPages: Int?
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}

// MARK: - Movie
struct Movie: Codable {
    let posterPath: String?
    let adult: Bool?
    let overview, releaseDate: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalTitle, originalLanguage , title, backdropPath: String?
    let popularity: Double?
    let voteCount: Int?
    let video: Bool?
    let voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case adult, overview
        case releaseDate = "release_date"
        case genreIDS = "genre_ids"
        case id
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case title
        case backdropPath = "backdrop_path"
        case popularity
        case voteCount = "vote_count"
        case video
        case voteAverage = "vote_average"
    }
    
    var wrappedTitle: String {
        title ?? originalTitle ?? "Unknown title"
    }
    
    var wrappedPopularity: Double {
        popularity ?? 0.0
    }
    
    var wrappedVoteCount: Int {
        voteCount ?? 0
    }
    
    var wrappedVoteAverage: Double {
        voteAverage ?? 0.0
    }
    
    var wrappedAdult: Bool {
        adult ?? false
    }
    
    var wrappedOverview: String {
        overview ?? "No overview"
    }
    
    var wrappedReleaseDate: String {
        releaseDate ?? "Unknown date"
    }
    
    var wrappedVideo: Bool {
        video ?? false
    }
    
    var wrappedPosterPath: String {
        Movie.imageBaseUrl + (posterPath ?? "")
    }
    
    var wrappedBackdropPath: String {
        Movie.imageBaseUrl + (backdropPath ?? "")
    }
}

extension Movie {
    
    static let imageBaseUrl = "https://image.tmdb.org/t/p/w154"
    
    static let fakedMovie = Movie(posterPath: "/5hNcsnMkwU2LknLoru73c76el3z.jpg", adult: false, overview: "Framed in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison, where he puts his accounting skills to work for an amoral warden. During his long stretch in prison, Dufresne comes to be admired by the other inmates -- including an older prisoner named Red -- for his integrity and unquenchable sense of hope.", releaseDate: "1994-09-10", genreIDS: [18, 80], id: 278, originalTitle: "The Shawshank Redemption", originalLanguage: "en", title: "The Shawshank Redemption", backdropPath: "/5hNcsnMkwU2LknLoru73c76el3z.jpg", popularity: 6.741296, voteCount: 5238, video: false, voteAverage: 8.32)
    
}

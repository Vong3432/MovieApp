//
//  MockMovieDataService.swift
//  MovieAppTests
//
//  Created by Vong Nyuksoon on 26/05/2022.
//

import Foundation
import Combine
@testable import MovieApp
import XCTest

final class MockMovieDataServiceFail: MovieDataServiceProtocol {
    func downloadData<T>(from url: String, as: T.Type, queries: [URLQueryItem]?) async throws -> T where T : Decodable, T : Encodable {
        throw APIError(statusMessage: "Cannot download data", success: false, statusCode: 500)
    }
    
    func downloadData<T>(from url: String, as: T.Type) -> AnyPublisher<T, Error> where T : Decodable, T : Encodable {
        return Fail(error: NSError(domain: "Error download", code: -10001, userInfo: nil))
            .eraseToAnyPublisher()
    }
}

final class MockMovieDataService: MovieDataServiceProtocol {
    func downloadData<T>(from url: String, as: T.Type, queries: [URLQueryItem]?) async throws -> T where T : Decodable, T : Encodable {
        if T.self == MovieDBResponse<Movie>.self {
            return MovieDBResponse<Movie>.init(page: 1, results: [.fakedMovie], totalResults: 1, totalPages: 1) as! T
        } else if T.self == MovieDBResponse<Video>.self {
            return MovieDBResponse<Video>.init(page: 1, results: [.mockedVideo], totalResults: 1, totalPages: 1) as! T
        } else if T.self == MovieDBResponse<Crew>.self {
            return MovieDBResponse<Crew>.init(page: 1, results: [.mockCrew], totalResults: 1, totalPages: 1) as! T
        } else if T.self == MovieDBResponse<Movie.Review>.self {
            return MovieDBResponse<Movie.Review>.init(page: 1, results: [.mockedReview], totalResults: 1, totalPages: 1) as! T
        } else if T.self == MovieDBResponse<Cast>.self {
            return MovieDBResponse<Cast>.init(page: 1, results: [.mockCast], totalResults: 1, totalPages: 1) as! T
        } else if T.self == Crew.self {
            return Crew.mockCrew as! T
        } else {
            throw APIError(statusMessage: "Cannot download data", success: false, statusCode: 500)
        }
    }
    
    func downloadData<T>(from url: String, as: T.Type) -> AnyPublisher<T, Error> where T : Decodable, T : Encodable {
        if T.self == MovieDBResponse<Movie>.self {
            return Just(MovieDBResponse<Movie>.init(page: 1, results: [.fakedMovie], totalResults: 1, totalPages: 1) as! T)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else if T.self == MovieDBResponse<Video>.self {
            return Just(MovieDBResponse<Video>.init(page: 1, results: [.mockedVideo], totalResults: 1, totalPages: 1) as! T)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else if T.self == MovieDBResponse<Crew>.self {
            return Just(MovieDBResponse<Crew>.init(page: 1, results: [.mockCrew], totalResults: 1, totalPages: 1) as! T)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else if T.self == MovieDBResponse<Movie.Review>.self {
            return Just(MovieDBResponse<Movie.Review>.init(page: 1, results: [.mockedReview], totalResults: 1, totalPages: 1) as! T)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else if T.self == MovieDBResponse<Cast>.self {
            return Just(MovieDBResponse<Cast>.init(page: 1, results: [.mockCast], totalResults: 1, totalPages: 1) as! T)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else if T.self == Crew.self {
            return Just(Crew.mockCrew as! T)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return Fail(error: NSError(domain: "Error download", code: -10001, userInfo: nil))
            .eraseToAnyPublisher()
    }
}

//
//  APIResponse.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 12/03/2022.
//

import Foundation

// MARK: - Success
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

/// - Tag: APIError
struct APIError: Codable, Error {
    let statusMessage: String?
    let success: Bool
    let statusCode: Int?

    enum CodingKeys: String, CodingKey {
        case statusMessage = "status_message"
        case success
        case statusCode = "status_code"
    }
}

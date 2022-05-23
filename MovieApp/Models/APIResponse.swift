//
//  APIResponse.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 12/03/2022.
//

import Foundation

// MARK: - API Response

struct MovieDBResponse<T>: Codable where T: Codable {
    let page: Int?
    let results: [T]?
    
    let totalResults, totalPages: Int?
    
//    enum CodingKeys: String, CodingKey {
//        case page, results
//        case totalResults = "total_results"
//        case totalPages = "total_pages"
//    }
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

// MARK: - Paginations

protocol Paginable: AnyObject {
    var currentPage: Int { get set }
    var totalPages: Int { get set }
}

struct PaginableValues {
    static let defaultCurrentPage = 0
    static let defaultTotalPages = 1
}

extension Paginable {
    /// - Returns:
    /// * True: Return true and also updates the url
    /// * False: Return false and don't update the url
    func shouldFetchNextPageUrl(url: inout String) -> Bool {
        guard currentPage < totalPages else {
            // we reach the final page, do nothing.
            return false
        }
        // if there is more to fetch,
        // then we will continue to fetch next page
        currentPage = currentPage + 1
        url += "?page=\(currentPage)"
        return true
    }
    
    /// - Returns:
    /// * True: Return true and also updates the url
    /// * False: Return false and don't update the url
    func shouldFetchPrevPageUrl(url: inout String)  -> Bool  {
        guard currentPage > 1 else {
            // we reach the first page, do nothing.
            return false
        }
        // if there is more to fetch,
        // then we will continue to fetch prev page
        currentPage = currentPage - 1
        url += "?page=\(currentPage)"
        return true
    }
    
    /// Reset ``currentPage`` to ``0``, and ``totalPages`` to ``1``
    func reset() {
        currentPage = PaginableValues.defaultCurrentPage
        totalPages = PaginableValues.defaultTotalPages
    }
}

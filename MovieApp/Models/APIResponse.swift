//
//  APIResponse.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 12/03/2022.
//

import Foundation

// MARK: - Error
struct APIError: Codable {
    let statusMessage: String?
    let success: Bool
    let statusCode: Int?

    enum CodingKeys: String, CodingKey {
        case statusMessage = "status_message"
        case success
        case statusCode = "status_code"
    }
}

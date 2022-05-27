//
//  Auth.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 17/05/2022.
//

import Foundation

struct LoginRequest: Encodable {
    let username: String
    let password: String
    let requestToken: String
}

struct CreateSessionID: Encodable {
    let requestToken: String
}

struct CreateSessionIDResponse: Decodable {
    let success: Bool
    let sessionId: String
}

struct CreateSessionResponse: Decodable {
    let success: Bool
    let expiresAt: String
    let requestToken: String
}

// MARK: - Account
struct Account: Codable {
    let avatar: Avatar?
    let id: Int
    let iso639_1, iso3166_1, name: String?
    let includeAdult: Bool?
    let username: String?
}

// MARK: - Avatar
struct Avatar: Codable {
    let gravatar: Gravatar?
}

// MARK: - Gravatar
struct Gravatar: Codable {
    let hash: String?
}

#if DEBUG
extension Account {
    static let mockedAccount = Account(avatar: Avatar(gravatar: Gravatar(hash: UUID().uuidString)), id: 1, iso639_1: nil, iso3166_1: nil, name: "John", includeAdult: nil, username: "john")
}
#endif

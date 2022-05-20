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

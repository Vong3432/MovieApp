//
//  AuthService.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 17/05/2022.
//

import Foundation

protocol AuthServiceProtocol {
    var isAuthenticated: Bool { get }
    var isAuthenticatedPublisher: Published<Bool>.Publisher { get }
    var isAuthenticatedPublished: Published<Bool> { get }
}

protocol AuthWithUsernamePassProtocol: AuthServiceProtocol {
    func login(username: String, password: String) async throws -> Void
}

protocol MovieDBAuthProtocol: AuthWithUsernamePassProtocol {
    func logout(_ sessionId: String) async throws  -> Void
}

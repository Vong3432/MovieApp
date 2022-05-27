//
//  MockMovieDBAuthService.swift
//  MovieAppTests
//
//  Created by Vong Nyuksoon on 26/05/2022.
//

import Foundation
@testable import MovieApp

final class MockMovieDBAuthServiceFail: MovieDBAuthProtocol {
    @Published var isAuthenticated: Bool = false
    var isAuthenticatedPublisher: Published<Bool>.Publisher { $isAuthenticated }
    var isAuthenticatedPublished: Published<Bool> { _isAuthenticated }
    
    @Published var account: Account? = nil
    var accountPublisher: Published<Account?>.Publisher { $account }
    var accountPublished: Published<Account?> { _account }
    
    private var sessionId: String? = nil
    
    func logout(_ sessionId: String) async throws {
        throw MovieDBAuthLoginError.apiError("Something went wrong")
    }
    
    func getSessionId() -> String? {
        return nil
    }
    
    func login(username: String, password: String) async throws {
        throw MovieDBAuthLoginError.incorrectCredential
    }
}

final class MockMovieDBAuthService: MovieDBAuthProtocol {
    @Published var isAuthenticated: Bool = false
    var isAuthenticatedPublisher: Published<Bool>.Publisher { $isAuthenticated }
    var isAuthenticatedPublished: Published<Bool> { _isAuthenticated }
    
    @Published var account: Account? = nil
    var accountPublisher: Published<Account?>.Publisher { $account }
    var accountPublished: Published<Account?> { _account }
    
    private var sessionId: String? = nil
    
    func logout(_ sessionId: String) async throws {
        isAuthenticated = false
        account = nil
    }
    
    func getSessionId() -> String? {
        sessionId
    }
    
    func login(username: String, password: String) async throws {
        sessionId = UUID().uuidString
        account = .mockedAccount
    }
}

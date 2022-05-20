//
//  MovieDBAuthService.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 17/05/2022.
//

import Foundation

enum MovieDBAuthLoginError: LocalizedError {
    case cannotCreateRequestToken
    case incorrectCredential
    case apiError(_ msg: String?)
    
    var errorDescription: String? {
        switch self {
        case .cannotCreateRequestToken:
            return "Something went wrong creating request token."
        case .incorrectCredential:
            return "Incorrect credential"
        case .apiError(let msg):
            return msg ?? "Unable to proceed"
        }
    }
}

final class MovieDBAuthService: MovieDBAuthProtocol {
    @Published var isAuthenticated: Bool = false
    var isAuthenticatedPublisher: Published<Bool>.Publisher { $isAuthenticated }
    var isAuthenticatedPublished: Published<Bool> { _isAuthenticated }
    
    private var sessionId: String? = nil
    
    init() {
        isAuthenticated = UserDefaults.standard.bool(forKey: .authenticated)
        sessionId = try? FileManager.decode(String.self, from: .movieDBSessionID)
    }
    
    private func createRequestToken() async throws -> CreateSessionResponse {
        guard let url = URL(string: APIEndpoints.createRequestTokenUrl) else { fatalError() }
        let responseData = try await NetworkingManager.download(url: url)
        return try MovieDBAPIResponseParser.decode(responseData)
    }
    
    func login(username: String, password: String) async throws {
        // Request token is needed to validate user login later
        let createRequestTokenResponse = try await createRequestToken()
        let auth = LoginRequest(username: username, password: password, requestToken: createRequestTokenResponse.requestToken)
        let createSessionID = CreateSessionID(requestToken: createRequestTokenResponse.requestToken)
        
        if let encodedAuth = try? MovieDBAPIResponseParser.encode(auth),
           let encodedSessionID = try? MovieDBAPIResponseParser.encode(createSessionID),
           let loginUrl = URL(string: APIEndpoints.createSessionWithLoginUrl),
           let createSessionIdUrl = URL(string: APIEndpoints.createSessionIDUrl)
        {
            // If no error after requesting token, then
            // we call login API to proceed
            let _ = try await NetworkingManager.post(url: loginUrl, body: encodedAuth)
            let createSessionResponse = try await NetworkingManager.post(url: createSessionIdUrl, body: encodedSessionID)
            
            let createSessionIDResponseDecoded: CreateSessionIDResponse = try MovieDBAPIResponseParser.decode(createSessionResponse)
            
            try FileManager.encode(createSessionIDResponseDecoded.sessionId, to: .movieDBSessionID)

            // login successfully.
            sessionId = createSessionIDResponseDecoded.sessionId
            isAuthenticated = true
        } else {
            // If something went wrong when requesting token
            isAuthenticated = false
            throw MovieDBAuthLoginError.cannotCreateRequestToken
        }
        
        UserDefaults.standard.set(isAuthenticated, forKey: .authenticated)
    }
    
    func logout(_ sessionId: String) async throws {
        isAuthenticated = false
        self.sessionId = nil
        
        guard let url = URL(string: APIEndpoints.logoutUrl),
              let encoded = try? MovieDBAPIResponseParser.encode(sessionId)
        else { return }
        
        let _ = try await NetworkingManager.delete(url: url, body: encoded)
        
        UserDefaults.standard.set(false, forKey: .authenticated)
    }
}


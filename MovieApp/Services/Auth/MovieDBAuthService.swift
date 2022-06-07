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
    
    @Published var account: Account? = nil
    var accountPublisher: Published<Account?>.Publisher { $account }
    var accountPublished: Published<Account?> { _account }
    
    private var sessionId: String? = nil
    
    init() {
        isAuthenticated = UserDefaults.standard.bool(forKey: .authenticated)
        sessionId = try? FileManager.decode(String.self, from: .movieDBSessionID)
        
        if let sessionId = sessionId {
            Task {
                try? await getAccount(sessionId)
            }
        }
    }
    
    func getSessionId() -> String? {
        return sessionId
    }
    
    private func createRequestToken() async throws -> CreateSessionResponse {
        guard let url = URL(string: APIEndpoints.createRequestTokenUrl.url) else { fatalError() }
        let responseData = try await NetworkingManager.download(url: url)
        return try MovieDBAPIResponseParser.decode(responseData)
    }
    
    private func getAccount(_ sessionId: String) async throws {
        guard let getAccountUrl = URL(string: APIEndpoints.getAccount.url) else { return }
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "session_id", value: sessionId)]
        
        let accountResponse = try await NetworkingManager.download(url: getAccountUrl, query: queryItems)
        let decodedAccount: Account = try MovieDBAPIResponseParser.decode(accountResponse)
        DispatchQueue.main.async {
            self.account = decodedAccount
            self.isAuthenticated = true
        }
    }
    
    func login(username: String, password: String) async throws {
        // Request token is needed to validate user login later
        let createRequestTokenResponse = try await createRequestToken()
        let auth = LoginRequest(username: username, password: password, requestToken: createRequestTokenResponse.requestToken)
        let createSessionID = CreateSessionID(requestToken: createRequestTokenResponse.requestToken)
        
        if let encodedAuth = try? MovieDBAPIResponseParser.encode(auth),
           let encodedSessionID = try? MovieDBAPIResponseParser.encode(createSessionID),
           let loginUrl = URL(string: APIEndpoints.createSessionWithLoginUrl.url),
           let createSessionIdUrl = URL(string: APIEndpoints.createSessionIDUrl.url)
        {
            // If no error after requesting token, then
            // we call login API to proceed
            let _ = try await NetworkingManager.post(url: loginUrl, body: encodedAuth)
            let createSessionResponse = try await NetworkingManager.post(url: createSessionIdUrl, body: encodedSessionID)
            let createSessionIDResponseDecoded: CreateSessionIDResponse = try MovieDBAPIResponseParser.decode(createSessionResponse)
            
            // login successfully.
            try FileManager.encode(createSessionIDResponseDecoded.sessionId, to: .movieDBSessionID)
            try await getAccount(createSessionIDResponseDecoded.sessionId)
            sessionId = createSessionIDResponseDecoded.sessionId
        } else {
            // If something went wrong when requesting token
            DispatchQueue.main.async {
                self.isAuthenticated = false
            }
            throw MovieDBAuthLoginError.cannotCreateRequestToken
        }
        
        UserDefaults.standard.set(isAuthenticated, forKey: .authenticated)
    }
    
    func logout(_ sessionId: String) async throws {
        isAuthenticated = false
        self.sessionId = nil
        
        guard let url = URL(string: APIEndpoints.logoutUrl.url),
              let encoded = try? MovieDBAPIResponseParser.encode(sessionId)
        else { return }
        
        let _ = try? await NetworkingManager.delete(url: url, body: encoded)
        
        try? FileManager().removeItem(at: FileManager.getDocumentsDirectory().appendingPathComponent(.movieDBSessionID))
        UserDefaults.standard.set(false, forKey: .authenticated)
    }
}


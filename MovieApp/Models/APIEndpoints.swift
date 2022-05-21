//
//  APIEndpoints.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 17/05/2022.
//

import Foundation

enum APIEndpoints {
    /// URL: https://api.themoviedb.org/3
    static let apiBaseUrl = "https://api.themoviedb.org/3"
    static let imageBaseUrl = "https://image.tmdb.org/t/p/w154"
    
    case createRequestTokenUrl
    case createSessionWithLoginUrl
    case createSessionIDUrl
    case logoutUrl
    case getFavoriteMovies(accountId: String)
    case markFavorite(id: String)
    case getAccount
    
    var url: String {
        switch self {
        case .createRequestTokenUrl:
            return "\(APIEndpoints.apiBaseUrl)/authentication/token/new"
        case .createSessionWithLoginUrl:
            return "\(APIEndpoints.apiBaseUrl)/authentication/token/validate_with_login"
        case .createSessionIDUrl:
            return "\(APIEndpoints.apiBaseUrl)/authentication/session/new"
        case .logoutUrl:
            return "\(APIEndpoints.apiBaseUrl)/authentication/session"
        case .getFavoriteMovies(let accountId):
            return "\(APIEndpoints.apiBaseUrl)/account/\(accountId)/favorite/movies"
        case .markFavorite(let accountId):
            return "\(APIEndpoints.apiBaseUrl)/account/\(accountId)/favorite"
        case .getAccount:
            return "\(APIEndpoints.apiBaseUrl)/account"
        }
    }
}

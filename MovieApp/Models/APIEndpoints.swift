//
//  APIEndpoints.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 17/05/2022.
//

import Foundation

struct APIEndpoints {
    /// URL: https://api.themoviedb.org/3
    static let apiBaseUrl = "https://api.themoviedb.org/3"
    static let imageBaseUrl = "https://image.tmdb.org/t/p/w154"
    static let createRequestTokenUrl = "\(apiBaseUrl)/authentication/token/new"
    static let createSessionWithLoginUrl = "\(apiBaseUrl)/authentication/token/validate_with_login"
    static let createSessionIDUrl = "\(apiBaseUrl)/authentication/session/new"
    static let logoutUrl = "\(apiBaseUrl)/authentication/session"
}

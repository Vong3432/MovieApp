//
//  String.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 12/03/2022.
//

import Foundation

extension String {
    /// URL: https://api.themoviedb.org/3
    static let apiBaseUrl = "https://api.themoviedb.org/3"
    static let imageBaseUrl = "https://image.tmdb.org/t/p/w154"
    
    /// Converting String date to Date
    var fromUTCtoDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let localDate = dateFormatter.date(from: self)
        
        return localDate ?? .distantPast
    }
}

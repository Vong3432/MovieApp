//
//  String.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 12/03/2022.
//

import Foundation

extension String {
    // UserDefault keys
    static let authenticated = "authenticated"
    
    // FileManager
    static let movieDBSessionID = "moviedbsessionid"
    
    /// Converting String date to Date
    var fromUTCtoDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let localDate = dateFormatter.date(from: self)
        
        return localDate ?? .distantPast
    }
}

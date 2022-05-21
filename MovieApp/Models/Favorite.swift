//
//  Favorite.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 20/05/2022.
//

import Foundation

enum FavoriteType {
    case movie
    case tv
    
    var text: String {
        switch self {
        case .movie:
            return "movie"
        case .tv:
            return "tv"
        }
    }
    
}

struct MarkFavoriteRequestBody: Encodable {
    let mediaType: String
    let mediaId: Int
    let favorite: Bool
}

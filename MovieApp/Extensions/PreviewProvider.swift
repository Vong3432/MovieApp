//
//  PreviewProvider.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 12/03/2022.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

class DeveloperPreview {
    static let instance = DeveloperPreview()
    
    private init() {} // prevent other to init a new instance of this class
    
    static let mockMovie = Movie.fakedMovie
    static let mockMovieList = [mockMovie]
}

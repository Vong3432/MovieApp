//
//  MovieDataService.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 12/03/2022.
//

import Foundation
import Combine

protocol MovieDataServiceProtocol {
    func downloadData<T>(from url: String, as: T.Type) -> AnyPublisher<T, Error> where T: Codable
}


enum MovieDataServiceError: LocalizedError {
    case apiError(_ msg: String?)
    
    var errorDescription: String? {
        switch self {
        case .apiError(let msg):
            return msg ?? "Unable to proceed"
        }
    }
}

class MovieDataService: MovieDataServiceProtocol {
    func downloadData<T>(from url: String, as: T.Type) -> AnyPublisher<T, Error> where T: Codable {
        guard let url = URL(string: url) else { return Fail(error: NSError(domain: "Fail to download", code: 500, userInfo: nil)).eraseToAnyPublisher() }
        return NetworkingManager
            .download(url: url)
            .decode(type: T.self, decoder: MovieDBAPIResponseParser.jsonDecoder)
            .eraseToAnyPublisher()
    }
}

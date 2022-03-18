//
//  MovieDataService.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 12/03/2022.
//

import Foundation
import Combine

class MovieDataService: ObservableObject {
    
    @Published var page: Int? = nil
    
//    private var cancellables = Set<AnyCancellable>()
    
    func downloadData<T>(from url: String, as: T.Type) -> AnyPublisher<T, Error> where T: Codable {
        guard let url = URL(string: url) else { return Fail(error: NSError(domain: "Fail to download", code: 500, userInfo: nil)).eraseToAnyPublisher() }

        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return NetworkingManager
            .download(url: url)
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}

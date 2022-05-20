//
//  MovieImageService.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 12/03/2022.
//

import Foundation
import UIKit
import Combine

class MovieImageService: ObservableObject {
    
    @Published var image: UIImage? = nil
    private var cancellables = Set<AnyCancellable>()
    private var imageCache = ImageCache.getImageCache()
    
    func loadImage(from url: String) {
        loadFromCache(url: url)
    }
    
    private func loadFromCache(url: String) {
        if let cachedImage = imageCache.get(forKey: url) {
            image = cachedImage
        } else {
            downloadImage(from: url)
        }
    }
    
    private func downloadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        NetworkingManager
            .download(url: url)
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] returnedImageData in
                guard let uiImage = UIImage(data: returnedImageData) else { return }
                
                self?.image = uiImage
                self?.imageCache.set(forKey: urlString, image: uiImage)
            }
            .store(in: &cancellables)
    }
}

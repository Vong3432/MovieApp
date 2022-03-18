//
//  MovieImageViewModel.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 12/03/2022.
//

import Foundation
import SwiftUI
import Combine

extension ImageView {
    class ImageViewModel: ObservableObject {
        
        @Published var image: Image? = nil
        @Published var isLoading = false
        
        private var dataService: MovieImageService = MovieImageService()
        private var cancellables = Set<AnyCancellable>()
        
        init(url: String) {
            fetchImage(from: url)
            subscribe()
        }
        
        private func fetchImage(from url: String) {
            isLoading = true
            dataService.loadImage(from: url)
        }
        
        private func subscribe() {
            dataService.$image
                .sink { [weak self] returnedImage in
                    self?.isLoading = false 
                    guard let returnedImage = returnedImage else { return }
                    self?.image = Image(uiImage: returnedImage)
                }
                .store(in: &cancellables)
        }
    }
}

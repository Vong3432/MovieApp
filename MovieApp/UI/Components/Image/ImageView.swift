//
//  MovieImageView.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 12/03/2022.
//

import SwiftUI

struct ImageView: View {
    
    @StateObject private var vm: ImageViewModel
    let url: String
    let height: Double
    
    init(url: String, height: Double = 300.0) {
        self.url = url
        self.height = height
        _vm = StateObject(wrappedValue: ImageViewModel(url: url))
    }
    
    var body: some View {
        
        if vm.isLoading || vm.image == nil {
            Image("placeholder")
                .resizable()
                .scaledToFit()
                .aspectRatio(16 / 9, contentMode: .fit)
                .background(Color.gray)
        } else {
            if let image = vm.image {
                image
                    .resizable()
                    .scaledToFit()
                    .background(Color.gray)
            }
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(url: DeveloperPreview.mockMovie.wrappedPosterPath)
            .frame(width: 300, height: 300)
            .previewLayout(.sizeThatFits)
    }
}

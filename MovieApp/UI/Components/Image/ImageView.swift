//
//  MovieImageView.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 12/03/2022.
//

import SwiftUI

struct ImageView: View {
    
    @StateObject private var vm: ImageViewModel
    @State private var placeholder = Image("placeholder")
    let url: String
    
    init(url: String) {
        self.url = url
        _vm = StateObject(wrappedValue: ImageViewModel(url: url))
    }
    
    var body: some View {
        if let image = vm.image {
            image
                .resizable()
                .scaledToFill()
                .background(Color.gray)
        } else {
            placeholder
                .resizable()
                .scaledToFill()
                .background(Color.gray)
        }
    }
    
    
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(url: DeveloperPreview.mockMovie.wrappedPosterPath)
            .frame(width: 300, height: 400)
//            .previewLayout(.sizeThatFits)
    }
}

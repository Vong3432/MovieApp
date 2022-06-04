//
//  MovieRowView.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 22/05/2022.
//

import SwiftUI

struct FavoriteMovieRowView: View {
    let movie: Movie

    var body: some View {
        HStack(alignment: .center, spacing: 18) {
            ImageView(url: movie.wrappedPosterPath)
                .scaledToFill()
                .frame(width: 52, height: 52)
                .cornerRadius(18)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(movie.wrappedTitle)
                    .font(.headline)
                
                Text(movie.wrappedOverview)
                    .lineLimit(2)
                    .font(.caption)
                    .opacity(0.75)
            }
        }
    }
}

struct FavoriteMovieRowView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteMovieRowView(movie: Movie.fakedMovie)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}

//
//  MovieRowView.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 22/05/2022.
//

import SwiftUI

struct MovieRowView: View {
    let movie: Movie
    var authService: MovieDBAuthProtocol
    var dataService: FavoritedDataServiceProtocol
    
    var body: some View {
        NavigationLink {
            MovieDetailView(movie: movie, authService: authService, favoriteService: dataService)
        } label: {
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
}

struct MovieRowView_Previews: PreviewProvider {
    static var previews: some View {
        MovieRowView(movie: Movie.fakedMovie, authService: MovieDBAuthService(), dataService: FavoritedDataService())
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
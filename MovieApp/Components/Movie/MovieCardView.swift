//
//  MovieCardView.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 12/03/2022.
//

import SwiftUI

struct MovieCardView: View {
    
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading) {
            ImageView(url: movie.wrappedPosterPath)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.wrappedTitle)
                    .font(.headline)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                HStack(alignment: .center, spacing: 8) {
                    Text(movie.wrappedVoteAverage.toOneDecimalString())
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    RatingView(rating: movie.wrappedVoteAverage)
                        .font(.caption)
                }
            }
            .padding(.vertical)
            
            Spacer()
        }
    }
    
}


struct MovieCardView_Previews: PreviewProvider {
    static var previews: some View {
        MovieCardView(movie: DeveloperPreview.mockMovie)
        //            .frame(width: 200, height: 400)
//                    .previewLayout(.sizeThatFits)
    }
}

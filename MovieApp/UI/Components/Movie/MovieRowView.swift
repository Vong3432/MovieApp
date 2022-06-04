//
//  MovieRowView.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 02/06/2022.
//

import SwiftUI

struct MovieRowView: View {
    let movie: Movie
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 20) {
            ImageView(url: movie.wrappedPosterPath)
                .scaledToFill()
                .frame(width: 100, height: 120)
                .cornerRadius(18)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(movie.wrappedTitle)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: false)
                
                Text(movie.wrappedOverview)
                    .lineLimit(2)
                    .font(.subheadline)
                    .opacity(0.75)
            }
            .multilineTextAlignment(.leading)
            .foregroundColor(.white)
        }
        
        
    }
}

struct MovieRowView_Previews: PreviewProvider {
    static var previews: some View {
        MovieRowView(movie: Movie.fakedMovie)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}

//
//  MovieRowView.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 02/06/2022.
//

import SwiftUI

struct MovieRowView: View {
    let idx: Int
    let movie: Movie
    
    @State private var opacity = 0.0
    
    /* Set upper bound limit otherwise the animation will take too long to start (delay for x secs) when the idx
     * is too big
     */
    private var upperBoundIdx: Double {
        idx < 20 ? Double(idx) : 20.0
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            ImageView(url: "\(APIEndpoints.imageBaseUrl)/w92/\(movie.wrappedPosterPath)")
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
        .opacity(opacity)
        .animation(.easeIn.delay(0.015 * upperBoundIdx), value: opacity)
        .onAppear {
            opacity = 1.0
        }
    }
}

struct MovieRowView_Previews: PreviewProvider {
    static var previews: some View {
        MovieRowView(idx: 0, movie: Movie.fakedMovie)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}

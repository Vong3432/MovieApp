//
//  ReviewView.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 18/03/2022.
//

import SwiftUI

struct ReviewView: View {
    let review: Movie.Review
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            
            HStack {
                Text(review.author)
                    .font(.subheadline)
                Spacer()
                Text(review.formattedCreatedAt)
                    .font(.footnote)
            }
                
            Text(review.content)
                .font(.footnote)
                .opacity(0.65)
                .lineLimit(15)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.2))
        .foregroundColor(.white)
        .cornerRadius(12)
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            ReviewView(review: Movie.Review.mockedReview)
                .previewLayout(.sizeThatFits)
        }
    }
}

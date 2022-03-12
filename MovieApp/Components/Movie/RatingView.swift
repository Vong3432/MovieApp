//
//  RatingView.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 12/03/2022.
//

import SwiftUI

struct RatingView: View {
    private let MAX_RATING: Double = 5.0 // Defines upper limit of the rating
    private let COLOR = Color.orange // The color of the stars
    
    let rating: Double
    private let fullCount: Int
    private let emptyCount: Int
    private let halfFullCount: Int
    
    init(rating: Double) {
        self.rating = rating - 5.0 <= 0 ? 0 : rating - 5.0 // since MovieDB max rating is 10
        fullCount = Int(self.rating)
        emptyCount = Int(MAX_RATING - self.rating)
        halfFullCount = (Double(fullCount + emptyCount) < MAX_RATING) ? 1 : 0
    }
    
    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<fullCount, id: \.self) { _ in
                self.fullStar
            }
            ForEach(0..<halfFullCount, id: \.self) { _ in
                self.halfFullStar
            }
            ForEach(0..<emptyCount, id: \.self) { _ in
                self.emptyStar
            }
        }
    }
    
    private var fullStar: some View {
        Image(systemName: "star.fill").foregroundColor(COLOR)
    }
    
    private var halfFullStar: some View {
        Image(systemName: "star.lefthalf.fill").foregroundColor(COLOR)
    }
    
    private var emptyStar: some View {
        Image(systemName: "star").foregroundColor(COLOR)
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: 4.5)
    }
}

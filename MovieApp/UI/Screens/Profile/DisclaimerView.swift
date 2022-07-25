//
//  DisclaimerView.swift
//  Moviecat
//
//  Created by Vong Nyuksoon on 21/07/2022.
//

import SwiftUI

struct DisclaimerView: View {
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 18) {
                Text("Disclaimer")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("This product uses the TMDB API but is not endorsed or certified by TMDB.")
                
                Spacer()
                
                Link("learn_more_at_TMDB_API", destination: URL(string: "https://www.themoviedb.org/documentation/api")!)
                    .frame(maxWidth: .infinity)
                    .buttonFilled()
                    .padding(.bottom)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }
}

struct DisclaimerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DisclaimerView()
        }
    }
}

//
//  CrewListView.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 18/03/2022.
//

import SwiftUI

struct CrewListView: View {
    let crew: Crew
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if let casts = crew.cast, casts.isNotEmpty {
                    ForEach(casts) { cast in
                        CrewView(person: cast)
                    }
                } else {
                    Text("No result")
                        .opacity(0.65)
                }
            }
        }
        .accessibilityIdentifier("CrewList")
        .padding([.horizontal, .bottom])
        .navigationTitle("all_casts_title")
    }
}

struct CrewListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CrewListView(crew: Crew.mockCrew)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}

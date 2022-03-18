//
//  CrewView.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 18/03/2022.
//

import SwiftUI

struct CrewView: View {
    let person: Cast
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            ImageView(url: .imageBaseUrl + person.wrappedProfilePath)
                .scaledToFill()
                .frame(width: 42, height: 42)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(person.wrappedName)
                    .font(.subheadline)
                Text(person.wrappedCharacter)
                    .font(.caption)
                    .italic()
                    .opacity(0.65)
            }
            
            Spacer()
        }
    }
}

struct CrewView_Previews: PreviewProvider {
    static var previews: some View {
        CrewView(person: Cast.mockCast)
            .previewLayout(.sizeThatFits)
    }
}

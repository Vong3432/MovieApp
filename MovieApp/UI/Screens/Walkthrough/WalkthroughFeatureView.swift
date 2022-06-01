//
//  WalkthroughDetailView.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 17/05/2022.
//

import SwiftUI

struct WalkthroughFeatureView: View {
    
    let walkthrough: Walkthrough
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            Spacer()
            Image(walkthrough.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 72, height: 72)
            
            VStack(alignment: .leading, spacing: 12) {
                Text(LocalizedStringKey(walkthrough.title))
                    .font(.headline)
                    .fontWeight(.medium)
                Text(LocalizedStringKey(walkthrough.description))
                    .font(.subheadline)
                    .opacity(0.7)
            }
            .multilineTextAlignment(.leading)
            Spacer()
        }
        .frame(height: 100)
        .preferredColorScheme(.dark)
        .customTint(Color.theme.primary)
    }
}

struct WalkthroughFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WalkthroughFeatureView(
                walkthrough: .walkthroughs[1]
            ).environment(\.locale, .init(identifier: "en"))
                .previewDisplayName("EN")
            
            WalkthroughFeatureView(
                walkthrough: .walkthroughs[1]
            ).environment(\.locale, .init(identifier: "zh-Hans"))
                .previewDisplayName("zhCN")
        }
    }
}

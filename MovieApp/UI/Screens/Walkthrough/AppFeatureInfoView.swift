//
//  AppFeatureInfoView.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 01/06/2022.
//

import SwiftUI

struct AppFeatureInfoView: View {
    
    @Binding var firstLaunched: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            Text("walkthrough_title")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            Spacer()
            ForEach(Walkthrough.walkthroughs) { WalkthroughFeatureView(walkthrough: $0)
                    .padding(.horizontal)
            }
            Spacer()
            Spacer()
            
            Button {
                finishWalkthrough()
            } label: {
                Text("continue")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .buttonFilled()
                    .clipShape(Capsule())
            }
            .padding()
            
            Spacer()
            
        }
        .preferredColorScheme(.dark)
        .customTint(Color.theme.primary)
    }
    
    private func finishWalkthrough() {
        firstLaunched = false
    }
}

struct AppFeatureInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AppFeatureInfoView(firstLaunched: .constant(false))
    }
}

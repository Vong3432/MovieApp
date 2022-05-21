//
//  WalkthroughScreen.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 17/05/2022.
//

import SwiftUI

struct WalkthroughView: View {
    
    @Binding var firstLaunched: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            Text("What's about the Movie APP")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            Spacer()
            ForEach(Walkthrough.walkthroughs) { WalkthroughDetailView(walkthrough: $0)
                    .padding(.horizontal)
            }
            Spacer()
            Spacer()
            
            Button {
                finishWalkthrough()
            } label: {
                Text("Continue")
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

struct WalkthroughView_Previews: PreviewProvider {
    static var previews: some View {
        WalkthroughView(firstLaunched: .constant(true))
    }
}

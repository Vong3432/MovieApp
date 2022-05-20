//
//  CloseFullScreenButton.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 18/05/2022.
//

import SwiftUI

struct CloseFullScreenButton: View {
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        Button {
            appState.closeSignInScreen()
        } label: {
            Image(systemName: "arrow.backward")
                .padding()
        }
    }
}

struct CloseFullScreenButton_Previews: PreviewProvider {
    static var previews: some View {
        CloseFullScreenButton()
            .environmentObject(AppState())
    }
}

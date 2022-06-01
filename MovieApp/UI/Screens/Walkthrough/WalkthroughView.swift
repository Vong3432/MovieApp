//
//  WalkthroughScreen.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 17/05/2022.
//

import SwiftUI

enum WalkThroughPage {
    case configLang
    case featureInfo
}

struct WalkthroughView: View {
    
    @Binding var firstLaunched: Bool
    @State private var currentPage: WalkThroughPage = .configLang
    
    private var isShowingLang: Bool { currentPage == .configLang }
    private var isShowingInfo: Bool { currentPage == .featureInfo }
    
    var body: some View {
        ZStack {
            ConfigLanguageView { selectedLang in
                onDoneConfigLang(lang: selectedLang)
            }
            
            AppFeatureInfoView(firstLaunched: $firstLaunched)
                .opacity(isShowingInfo ? 1 : 0)
                .offset(x: 0, y: isShowingInfo ? 0 : 300)
                
        }
        .preferredColorScheme(.dark)
    }
    
    private func onDoneConfigLang(lang: String) {
        // show next
        withAnimation(.spring().delay(0.85)) {
            self.currentPage = .featureInfo
        }
    }
}

struct WalkthroughView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WalkthroughView(firstLaunched: .constant(true))
                .environment(\.locale, .init(identifier: "en"))
                .previewDisplayName("EN")
//            WalkthroughView(firstLaunched: .constant(true))
//                .environment(\.locale, .init(identifier: "zh-Hans"))
//                .previewDisplayName("CN")
        }
    }
}


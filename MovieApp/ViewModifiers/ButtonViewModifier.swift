//
//  ButtonViewModifier.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 21/05/2022.
//

import Foundation
import SwiftUI

struct ButtonViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.theme.primary)
            .foregroundColor(.white)
            .cornerRadius(12)
    }
}

extension View {
    func buttonFilled() -> some View {
        return modifier(ButtonViewModifier())
    }
}

//
//  ButtonViewModifier.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 21/05/2022.
//

import Foundation
import SwiftUI

struct ButtonViewModifier: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(12)
    }
}

extension View {
    func buttonFilled(with color: Color = Color.theme.primary) -> some View {
        return modifier(ButtonViewModifier(color: color))
    }
}

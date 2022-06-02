//
//  TextFieldViewModifier.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 02/06/2022.
//

import Foundation
import SwiftUI

extension View {
    func filledTextFieldStyle(radius: CGFloat = 12.0) -> some View {
        modifier(TextFieldViewModifier(radius: radius))
    }
}

struct TextFieldViewModifier: ViewModifier {
    let radius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .textFieldStyle(.plain)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(radius)
    }
}

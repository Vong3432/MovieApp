//
//  ScrollWithSnap.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 11/06/2022.
//

import SwiftUI

struct ScrollWithSnap<Content>: View where Content: View {
    
    let widthOfEachItem: Double
    let heightOfEachItem: Double?
    let widthOfHiddenCards: Double
    let spacing: Double
    let items: Int
    let content: Content
    
    @State private var currentIndex = 0
    @State private var dragOffset: Double = 0.0
    @State private var scrollOffset: Double = 0.0
    @GestureState private var isLongPressing = false
    
    init(widthOfEachItem: Double, heightOfEachItem: Double? = 0.0, widthOfHiddenCards: Double? = 32.0, spacing: Double? = 0.0, items: Int, @ViewBuilder content: @escaping () -> Content) {
        self.widthOfEachItem = widthOfEachItem
        self.widthOfHiddenCards = widthOfHiddenCards ?? 32.0
        self.spacing = spacing ?? 0.0
        self.items = items
        self.content = content()
        self.heightOfEachItem = heightOfEachItem ?? widthOfEachItem
    }
    
    var body: some View {
        let totalSpacing = Double(items - 1) * spacing
        let totalCanvasWidth: Double = (widthOfEachItem * Double(items)) + totalSpacing
        let xOffsetToShift = (totalCanvasWidth - UIScreen.main.bounds.width) / 2
        let leftPadding = widthOfHiddenCards + spacing
        let totalMovement = widthOfEachItem + spacing
        
        let activeOffset = xOffsetToShift + (leftPadding) - (totalMovement * Double(currentIndex))
        let nextOffset = xOffsetToShift + (leftPadding) - (totalMovement * Double(currentIndex) + 1)
        
        var calcOffset = Double(activeOffset)
        
        if (calcOffset != Double(nextOffset)) {
            calcOffset = Double(activeOffset) + dragOffset
        }
        
        return LazyHStack(alignment: .center, spacing: spacing) {
            content
        }
        .offset(x: calcOffset, y: 0)
        .highPriorityGesture(
            DragGesture()
                .onChanged { value in
                    dragOffset = value.translation.width
                }
                .onEnded { value in
                    withAnimation(.spring()) {
                        dragOffset = 0
                        
                        if value.translation.width > 50 {
                            if currentIndex > 0 {
                                currentIndex -= 1
                            }
                        } else if value.translation.width < -50 {
                            if currentIndex < items - 1 {
                                currentIndex += 1
                            }
                        }
                    }
                }
        )
    }

}

struct ScrollWithSnap_Previews: PreviewProvider {
    static var previews: some View {
        ScrollWithSnap(
            widthOfEachItem: 200,
            items: Movie.fakedList.count) {
            }
    }
}

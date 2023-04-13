//
//  View+AnimatedHeight.swift
//  Demopet
//
//  Created by Nik Y on 09.04.2023.
//

import SwiftUI

struct AnimatedHeight: AnimatableModifier {
    var height: CGFloat
    var animatableData: CGFloat {
        get { height }
        set { height = newValue }
    }

    func body(content: Content) -> some View {
        content
            .frame(height: height)
    }
}

extension View {
    func animatedHeight(_ height: CGFloat) -> some View {
        self.modifier(AnimatedHeight(height: height))
    }
}

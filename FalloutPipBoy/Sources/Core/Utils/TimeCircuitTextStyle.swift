//
//  TimeCircuitTextStyle.swift
//  FalloutPipBoy
//
//  Created by Arkadiy KAZAZYAN on 21/08/2025.
//

import SwiftUI

struct TimeCircuitTextStyle: ViewModifier {
    var size: CGFloat
    var color: Color
    func body(content: Content) -> some View {
        content
            .font(.custom("Digital-7Italic", size: size))
            .dynamicTypeSize(.medium)
            .foregroundColor(color)
            .padding(.horizontal, 2)
            .background {
                Rectangle()
                    .foregroundStyle(.black)
            }
            
    }
}

extension View {
    func circuitText(size: CGFloat = 18, color: Color = .green) -> some View {
        self.modifier(TimeCircuitTextStyle(size: size, color: color))
    }
}

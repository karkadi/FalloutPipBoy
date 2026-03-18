//
//  TimeCircuitTextStyle.swift
//  FalloutPipBoy
//
//  Created by Arkadiy KAZAZYAN on 21/08/2025.
//

import SwiftUI

struct TimeCircuitTextStyle: ViewModifier {
    let size: CGFloat
    let width: CGFloat
    let color: Color
    func body(content: Content) -> some View {
        content
            .font(.custom("Digital-7Italic", size: size))
            .dynamicTypeSize(.small)
            .foregroundColor(color)
            .padding(.horizontal, 2)
            .background {
                Rectangle()
                    .foregroundStyle(.black)
                    .frame(width: width)
            }
            
    }
}

extension View {
    func circuitText(size: CGFloat = 18, width: CGFloat = 20, color: Color = .green) -> some View {
        self.modifier(TimeCircuitTextStyle(size: size, width: width, color: color))
    }
}

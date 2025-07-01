//
//  PipboyTextStyle.swift
//  FalloutPipBoy
//
//  Created by Arkadiy KAZAZYAN on 02/07/2025.
//

import SwiftUI

struct PipboyTextStyle: ViewModifier {
    var size: CGFloat
    var color: Color = .green
    func body(content: Content) -> some View {
        content
            .font(.custom("Courier", size: size))
            .dynamicTypeSize(.medium)
            .fontWeight(.bold)
            .foregroundColor(color)
    }
}

extension View {
    func pipboyText(size: CGFloat, color: Color = .green) -> some View {
        self.modifier(PipboyTextStyle(size: size, color: color))
    }
}

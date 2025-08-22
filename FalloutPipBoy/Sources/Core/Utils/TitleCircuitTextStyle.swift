//
//  TitleCircuitTextStyle.swift
//  FalloutPipBoy
//
//  Created by Arkadiy KAZAZYAN on 29/09/2025.
//
import SwiftUI

struct TitleCircuitTextStyle: ViewModifier {
    var size: CGFloat
    var color: Color
    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: .bold, design: .monospaced))
              .foregroundColor(.white)
              .padding(.horizontal, 2)
              .background {
                  Rectangle()
                      .foregroundStyle(color)
              }
            
    }
}

extension View {
    func titleCircuitText(size: CGFloat = 6, color: Color = Color(red: 0.52, green: 0.16, blue: 0.09)) -> some View {
        self.modifier(TitleCircuitTextStyle(size: size, color: color))
    }
}

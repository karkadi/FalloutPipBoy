//
//  Needle.swift
//  FalloutPipBoy
//
//  Created by Arkadiy KAZAZYAN on 29/09/2025.
//

import SwiftUI

// Needle shape
struct Needle: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius = rect.height/3
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        path.move(to: center)
        path.addLine(to: CGPoint(x: center.x,
                                 y: center.y - radius))
        
        return path
    }
    
}

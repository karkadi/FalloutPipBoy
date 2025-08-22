//
//  FluxCapacitorView.swift
//  FalloutPipBoy
//
//  Created by Arkadiy KAZAZYAN on 19/08/2025.
//

import SwiftUI

struct FluxCapacitorView: View {
    var glowColor: Color = Color.white
    var backgroundColor: Color = Color.black
    var speed: Double = 60.0 // the speed of the impulse
    @State private var phase: CGFloat = 0
    
    var body: some View {
        TimelineView(.animation) { _ in
            ZStack {
                Image("fluxCapacitor")
                    .resizable()
                    .scaledToFit()
                
                GeometryReader { geo in
                    let rect = geo.size
                    let size = min(rect.width, rect.height)
                    let center = CGPoint(x: rect.width/2, y: rect.height/2)
                    let radius = size * 0.17
                    let tubeWidth = size * 0.1
                    let vertices = equilateralVertices(center: center, radius: radius, rotation: .pi/2)
                    let centerOffset = equilateralVertices(center: center, radius: radius * 0.2, rotation: .pi/2)
                    
                    // Three "tubes" from the center to the vertices
                    ForEach(0..<3) { index in
                        let vertice = [vertices.0, vertices.1, vertices.2][index]
                        let radius = [centerOffset.0, centerOffset.1, centerOffset.2][index]
                        
                        // Running pulse (dashed line with phase)
                        TubePath(from: radius, to: vertice)
                            .stroke(glowColor,
                                    style: StrokeStyle(
                                        lineWidth: tubeWidth * 0.5,
                                        lineCap: .butt,
                                        dash: [tubeWidth * 1.4, tubeWidth * 1.4],
                                        dashPhase: phase
                                    )
                            )
                            .shadow(color: glowColor, radius: 8)
                            .blendMode(.normal)
                    }
                    
                }
            }
            .onAppear {
                withAnimation(.linear(duration: speed).repeatForever(autoreverses: false)) {
                    phase = 2000 // large initial offset - will "run"
                }
            }
        }
    }
    
    // Vertices of an equilateral triangle
    private func equilateralVertices(center: CGPoint, radius: CGFloat, rotation: CGFloat = 0) -> (CGPoint, CGPoint, CGPoint) {
        func point(_ angle: CGFloat) -> CGPoint {
            CGPoint(
                x: center.x + cos(angle + rotation) * radius,
                y: center.y + sin(angle + rotation) * radius
            )
        }
        return (point(0), point(3 * .pi / 4), point( 5 * .pi / 4))
    }
}

// MARK: - Preview
#Preview {
    Group {
        FluxCapacitorView()
            .frame(width: 50, height: 50)
        
        FluxCapacitorView(glowColor: .yellow, speed: 10.6)
            .preferredColorScheme(.dark)
    }
    .background(Color.black)
}

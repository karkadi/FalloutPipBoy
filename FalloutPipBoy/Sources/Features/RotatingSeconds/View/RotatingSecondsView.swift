//
//  RotatingSecondsView.swift
//  FalloutPipBoy
//
//  Created by Arkadiy KAZAZYAN on 17/08/2025.
//

import SwiftUI

struct RotatingSecondsView: View {
    @State private var viewModel = RotatingSecondsViewModel()

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let radiusSec = size * 0.55
            let radiusMin = size * 0.38
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)

            let arcOffset = size * 0.28
            let arcRadius = size * 0.10
            let arcYSize = size * 0.10

            let digitFontSize = size * 0.08
            let hourFontSize = size * 0.3

            let markerLong = size * 0.06
            let markerShort = size * 0.03
            let markerYOffsetLong = -size * 0.068
            let markerYOffsetShort = -size * 0.08

            ZStack {
                // minutes
                ForEach(0..<12) { second in
                    let angle = Double(second + 16) / 12.0 * 360.0
                    let rotation = Angle.degrees(angle + Double(viewModel.minutes) / 60.0 * 360.0)
                    Text(String(format: "%02d", 55 - second * 5))
                        .font(.custom("monofonto", size: digitFontSize))
                        .foregroundColor(.white)
                        .rotationEffect(Angle.degrees(270))
                        .position(x: center.x, y: center.y - radiusMin)
                        .rotationEffect(rotation, anchor: .center)
                }

                Path { path in
                    path.move(to: CGPoint(x: geometry.size.width, y: center.y - arcYSize))
                    path.addLine(to: CGPoint(x: geometry.size.width - arcOffset, y: center.y - arcYSize))
                    path.addArc(center: CGPoint(x: geometry.size.width - arcOffset, y: center.y),
                                radius: arcRadius,
                                startAngle: .degrees(270),
                                endAngle: .degrees(90),
                                clockwise: true)
                    path.addLine(to: CGPoint(x: geometry.size.width, y: center.y + arcYSize))
                    path.closeSubpath()
                }
                .foregroundStyle(.black)

                Text(String(format: "%02d", viewModel.minutes))
                    .font(.custom("monofonto", size: digitFontSize * 1.3))
                    .foregroundColor(.white)
                    .position(x: geometry.size.width - arcOffset + 2, y: center.y)

                // seconds ; Rotating digits
                ForEach(0..<12) { second in
                    let angle = Double(second + 16) / 12.0 * 360.0
                    let rotation = Angle.degrees(angle + viewModel.preciseSecond / 60.0 * 360.0)

                    ZStack {
                        Text(String(format: "%02d", 55 - second * 5))
                            .font(.custom("monofonto", size: digitFontSize))
                            .foregroundColor(.white)
                            .rotationEffect(Angle.degrees(270))
                            .position(x: center.x, y: center.y - radiusSec)
                            .rotationEffect(rotation, anchor: .center)

                        Text(String(format: "%02d", 55 - second * 5))
                            .font(.custom("monofonto", size: digitFontSize))
                            .foregroundColor(.red)
                            .rotationEffect(Angle.degrees(270))
                            .position(x: center.x, y: center.y - radiusSec)
                            .rotationEffect(rotation, anchor: .center)
                            .mask(
                                Path { path in
                                    path.move(to: CGPoint(x: geometry.size.width, y: center.y - arcYSize))
                                    path.addLine(to: CGPoint(x: geometry.size.width - arcOffset, y: center.y - arcYSize))
                                    path.addArc(center: CGPoint(x: geometry.size.width - arcOffset, y: center.y),
                                                radius: arcRadius,
                                                startAngle: .degrees(270),
                                                endAngle: .degrees(90),
                                                clockwise: true)
                                    path.addLine(to: CGPoint(x: geometry.size.width, y: center.y + arcYSize))
                                    path.closeSubpath()
                                }
                            )
                    }
                }

                ForEach(0..<60) { second in
                    let angle = Double(second)
                    let rotation = Angle.degrees(angle / 60.0 * 360.0)

                    Rectangle()
                        .frame(width: 1.5, height: second % 5 == 0 ? markerLong : markerShort)
                        .foregroundColor(.gray)
                        .position(x: center.x, y: center.y - radiusSec + (second % 5 == 0 ? markerYOffsetLong : markerYOffsetShort))
                        .rotationEffect(rotation, anchor: .center)
                }

                Text(String(format: "%02d", viewModel.hour))
                    .font(.custom("monofonto", size: hourFontSize))
                    .foregroundColor(.white)

                ForEach(0..<60) { second in
                    let angle = Double(second)
                    let rotation = Angle.degrees(angle / 60.0 * 360.0)

                    Rectangle()
                        .frame(width: 1.5, height: second % 5 == 0 ? markerLong : markerShort)
                        .foregroundColor(.gray)
                        .position(x: center.x, y: center.y - radiusMin + (second % 5 == 0 ? markerYOffsetLong : markerYOffsetShort))
                        .rotationEffect(rotation, anchor: .center)
                }

                #if !DEBUG
                // Fixed current second at the right
                HStack {
                    Group {
                        Text(Date(), style: .time)
                        Text(":\(viewModel.secondFraction)")
                    }
                    .font(.system(size: digitFontSize, weight: .bold, design: .rounded))
                    .foregroundColor(.red)
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2 + size * 0.18)
                #endif

                Path { path in
                    path.move(to: CGPoint(x: geometry.size.width, y: center.y - arcYSize))
                    path.addLine(to: CGPoint(x: geometry.size.width - arcOffset, y: center.y - arcYSize))
                    path.addArc(center: CGPoint(x: geometry.size.width - arcOffset, y: center.y),
                                radius: arcRadius,
                                startAngle: .degrees(270),
                                endAngle: .degrees(90),
                                clockwise: true)
                    path.addLine(to: CGPoint(x: geometry.size.width, y: center.y + arcYSize))
                }
                .stroke(.white, lineWidth: 2.5)

            }
        }
        .background(Color.black)
    }
}

#Preview {
    RotatingSecondsView()
}

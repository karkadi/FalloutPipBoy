//
//  TimeDisplaySection.swift
//  FalloutPipBoy
//
//  Created by Arkadiy KAZAZYAN on 29/09/2025.
//
import SwiftUI

struct TimeDisplaySection: View {
    
    let geoSize: CGSize
    let month: String
    let day: Int
    let hour: Int
    let year: String
    let min: Int
    
    let digitsColor: Color
    let title: String
    let isOn: Bool
    
    var body: some View {
        
        let totalWidth = geoSize.width
        let scale = Swift.min(totalWidth / 200.0, 2.0) // Scale based on width, max 2x
        let fontSize = 14 * scale
        let titleSize = 7 * scale
        let spacing = 8 * scale
        let circleSize = 3 * scale
        
        VStack(spacing: 0) {
            HStack(spacing: spacing) {
                // MONTH
                VStack(spacing: 1) {
                    Text("MONTH")
                        .titleCircuitText(size: 6 * scale)
                    Text(month)
                        .circuitText(size: fontSize, width: 27 * scale, color: digitsColor)
                }
                
                // DAY
                VStack(spacing: 1) {
                    Text("DAY")
                        .titleCircuitText(size: 6 * scale)
                    Text(String(format: "%02d", day))
                        .circuitText(size: fontSize, width: 18 * scale, color: digitsColor)
                }
                
                // YEAR
                VStack(spacing: 1) {
                    Text("YEAR")
                        .titleCircuitText(size: 6 * scale)
                    Text(String(year))
                        .circuitText(size: fontSize, width: 36 * scale, color: digitsColor)
                        .frame(width: 36 * scale)
                }
                .offset(x: 5.0 * scale)
                
                // HOUR
                VStack(spacing: 1) {
                    Text("HOUR")
                        .titleCircuitText(size: 6 * scale)
                    Text(String(format: "%02d", hour))
                        .circuitText(size: fontSize, width: 18 * scale, color: digitsColor)
                }
                .offset(x: 8.0 * scale)
                
                // Colon separator
                VStack(spacing: 0.3 * spacing) {
                    Circle()
                        .fill(isOn ? .black : digitsColor)
                        .frame(width: circleSize, height: circleSize)
                        .blur(radius: 0.5)
                        .padding(.top)
                    
                    Circle()
                        .fill(isOn ? .black : digitsColor)
                        .frame(width: circleSize, height: circleSize)
                        .blur(radius: 0.5)
                }
                .offset(x: 4.0 * scale)
                
                // MIN
                VStack(spacing: 1) {
                    Text("MIN")
                        .titleCircuitText(size: 6 * scale)
                    Text(String(format: "%02d", min))
                        .circuitText(size: fontSize, width: 18 * scale, color: digitsColor)
                }
            }
            .frame(maxWidth: .infinity)
            
            Text(title)
                .font(.system(size: titleSize, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
                .padding(.horizontal, 2)
                .padding(.vertical, 1)
                .background {
                    Rectangle()
                        .foregroundStyle(.black)
                }
                .padding(.top, 2 * scale)
        }
    }
}

#Preview {
    GeometryReader { geometry in
        TimeDisplaySection(
            geoSize: geometry.size,
            month: "AUG",
            day: 26,
            hour: 21,
            year: "2025",
            min: 0,
            digitsColor: .red,
            title: "Destination Time",
            isOn: true
        )
        .background(Color(.gray))
        .ignoresSafeArea(.all)
    }
}

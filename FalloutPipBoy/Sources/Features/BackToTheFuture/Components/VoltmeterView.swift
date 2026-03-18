//
//  VoltmeterView.swift
//  FalloutPipBoy
//
//  Created by Arkadiy KAZAZYAN on 24/08/2025.
//

import SwiftUI

struct VoltmeterView: View {
    var currentVoltage: Double = 85.0
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                // Outer circle
                Image("geigerCounter")
                    .resizable()
                    .scaledToFit()
                
                // Needle
                Needle()
                    .stroke(Color.red, lineWidth: 1)
                    .rotationEffect(.degrees(needleAngle), anchor: .center)
                    .animation(.easeInOut, value: needleAngle)
                    .offset( y: geometry.size.height/12.0)
                
                // Center pin
                Circle()
                    .fill(Color.red)
                    .frame(width: geometry.size.height/12.0, height: geometry.size.height/12.0)
                    .offset(y: geometry.size.height/12.0)
            }
        }
        
    }
    
    private var needleAngle: Double {
        // Convert voltage to angle (-90° to 90° for 0-100V range)
        return (currentVoltage / 100.0 * 180.0) - 90.0
    }

}

// Preview
#Preview {
    VoltmeterView()
        .frame(width: 160, height: 160)
}

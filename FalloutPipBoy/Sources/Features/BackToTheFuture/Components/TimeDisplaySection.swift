//
//  TimeDisplaySection.swift
//  FalloutPipBoy
//
//  Created by Arkadiy KAZAZYAN on 29/09/2025.
//
import SwiftUI

struct TimeDisplaySection: View {
    
    let month: String
    let day: Int
    let hour: Int
    let year: Int
    let min: Int
    
    let digitsColor: Color
    let title: String
    let isOn: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                VStack(spacing: 1) {
                    
                    Text("MONTH")
                        .titleCircuitText()
                    Text(month)
                        .circuitText(color: digitsColor)
                }
                Spacer()
                    .frame(width: 4)
                
                VStack(spacing: 1) {
                    Text("DAY")
                        .titleCircuitText()
                    Text(String(format: "%.2d", day ))
                        .circuitText(color: digitsColor)
                }
                Spacer()
                    .frame(width: 4)
                VStack(spacing: 1) {
                    Text("YEAR")
                        .titleCircuitText()
                    
                    Text(String(format: "%d", year ))
                        .circuitText(color: digitsColor)
                }
                Spacer()
                    .frame(width: 4)
                VStack(spacing: 1) {
                    Text("HOUR")
                        .titleCircuitText()
                    Text(String(format: "%.2d", hour ))
                        .circuitText(color: digitsColor)
                }
  
                VStack(spacing: 1) {
                    Spacer()
                Image(systemName: "circle.fill")
                        .resizable()
                        .scaledToFill()
                        .foregroundStyle(isOn ? .black : digitsColor)
                        .frame(width: 5, height: 5)
                        .blur(radius: 0.6)
                    
                    Image(systemName: "circle.fill")
                        .resizable()
                        .scaledToFill()
                            .foregroundStyle(isOn ? .black : digitsColor)
                            .frame(width: 5, height: 5)
                            .padding(.bottom, 4)
                            .blur(radius: 0.6)
                }
                .padding(.horizontal, 1)
                .offset(x: -1, y: -10)
                
                VStack(spacing: 1) {
                    Text("MIN")
                        .titleCircuitText()
                    Text(String(format: "%.2d", min ))
                        .circuitText(color: digitsColor)
                }
                
            }
            
            Text(title)
                .font(.system(size: 8, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
                .padding(.horizontal, 2)
                .background {
                    Rectangle()
                        .foregroundStyle(.black)
                }
                .padding(.top, 0)
            
        }
        .padding(.vertical, 2)
        .padding(.horizontal, 12)
        
    }
}

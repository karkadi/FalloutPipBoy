//
//  TimeCircuitsView.swift
//  FalloutPipBoy
//
//  Created by Arkadiy KAZAZYAN on 21/08/2025.
//

import SwiftUI
internal import Combine

struct TimeCircuitsView: View {
    @StateObject private var viewModel = TimeCircuitsViewModel()
    @State private var isOn: Bool = false
    @State private var currentVoltage: Double = 0.0
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack(alignment: .leading) {
            
            Image("circuitBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.all)
            
            VStack(alignment: .center, spacing: 0) {
                HStack {
                    FluxCapacitorView()
                        .frame(width: 50, height: 50)
                    
                    VStack(spacing: 0) {
                        VoltmeterView(currentVoltage: currentVoltage)
                            .frame(width: 40, height: 35)

                        Text(String(format: "%.2d", viewModel.dateComponents.second ?? 0 ))
                            .frame(width: 26)
                            .circuitText(size: 22, color: Color(red: 0.93, green: 0.814, blue: 0.309))
                    }
                    .offset(y: 10)
                    Spacer()
                        .frame(width: 40)
                }
                
                // Destination Time
                TimeDisplaySection(month: "AUG",
                                   day: 26,
                                   hour: 21,
                                   year: 1985,
                                   min: 0,
                                   digitsColor: Color(red: 0.93, green: 0.43, blue: 0.19),
                                   title: "DESTINATION TIME", isOn: isOn)
                
                Divider()
                // Present Time
                TimeDisplaySection(month: viewModel.month,
                                   day: viewModel.dateComponents.day ?? 1,
                                   hour: viewModel.dateComponents.hour ?? 0,
                                   year: viewModel.dateComponents.year ?? 1999,
                                   min: viewModel.dateComponents.minute ?? 0,
                                   digitsColor: Color(red: 0.57, green: 0.977, blue: 0.384),
                                   title: "PRESENT TIME", isOn: isOn)
                
                Divider()
                // Last Time Departed
                TimeDisplaySection(month: "NOV",
                                   day: 12,
                                   hour: 6,
                                   year: 1955,
                                   min: 38,
                                   digitsColor: Color(red: 0.93, green: 0.814, blue: 0.309),
                                   title: "LAST TIME DEPARTED", isOn: isOn)
                
            }
            .padding(.horizontal, 16)
            .ignoresSafeArea(.all)
        }
        .onAppear {
            viewModel.startUpdates()
  
        }
        .onDisappear {
            viewModel.stopUpdates()
        }
        .onReceive(timer) { _ in
            isOn.toggle()
            currentVoltage = Double.random(in: 20...80)
        }
    }
}

#Preview {
    TimeCircuitsView()
}

//
//  TimeCircuitsView.swift
//  FalloutPipBoy
//
//  Created by Arkadiy KAZAZYAN on 21/08/2025.
//

import SwiftUI

struct TimeCircuitsView: View {
    @State private var viewModel = TimeCircuitsViewModel()
    @State private var isOn: Bool = false
    @State private var currentVoltage: Double = 0.0
    
    var body: some View {
        ZStack(alignment: .leading) {
            
            Image("circuitBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.all)
            GeometryReader { geometry in
                let scale = Swift.min(geometry.size.height / 200.0, 2.0) // Scale based on width, max 2x
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 30) {
                        FluxCapacitorView()
                            .frame(width: 60, height: 60)
                            .offset(x: 30, y: 10)
                        
                            VoltmeterView(currentVoltage: currentVoltage)
                                .frame(width: 60, height: 50)
                                .offset(x: -4, y: 10)
                            
                            Text(String(format: "%.2d", viewModel.dateComponents.second ?? 0 ))
                                .circuitText(size: 22, width: 30, color: Color(red: 0.93, green: 0.814, blue: 0.309))
                                .frame(width: 30)
                                .offset(x: -20, y: 20)
                    }
                    
                    // Destination Time
                    TimeDisplaySection(geoSize: geometry.size,
                                       month: "AUG",
                                       day: 26,
                                       hour: 21,
                                       year: viewModel.monthYear,
                                       min: 0,
                                       digitsColor: .destinationColor,
                                       title: "DESTINATION TIME", isOn: isOn)
                    .offset(y: 15.0 * scale)
                    
                    Divider()
                        .offset(y: 20.0 * scale)
                    // Present Time
                    TimeDisplaySection(geoSize: geometry.size,
                                       month: viewModel.month,
                                       day: viewModel.dateComponents.day ?? 1,
                                       hour: viewModel.dateComponents.hour ?? 0,
                                       year: String("\(viewModel.dateComponents.year ?? 1999)"),
                                       min: viewModel.dateComponents.minute ?? 0,
                                       digitsColor: .presentColor,
                                       title: "PRESENT TIME", isOn: isOn)
                    .offset(y: 25.0 * scale)
                    
                    Divider()
                        .offset(y: 30.0 * scale)
                    // Last Time Departed
                    TimeDisplaySection(geoSize: geometry.size,
                                       month: "NOV",
                                       day: 12,
                                       hour: 6,
                                       year: "1955",
                                       min: 38,
                                       digitsColor: .lastTimeColor,
                                       title: "LAST TIME DEPARTED", isOn: isOn)
                    .offset(y: 35.0 * scale)
                    
                }
                .ignoresSafeArea(.all)
                .onTapGesture {
                    viewModel.toggleDestinationTime()
                }
            }
        }
        .onAppear {
            viewModel.startUpdates()
            startTimer()
        }
        .onDisappear {
            viewModel.stopUpdates()
        }
    }
    
    private func startTimer() {
        Task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
                await MainActor.run {
                    isOn.toggle()
                    currentVoltage = Double.random(in: 20...80)
                }
            }
        }
    }
}

#Preview {
    TimeCircuitsView()
}

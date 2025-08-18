//
//  ContentView.swift
//  FalloutPipBoy Watch App
//
//  Created by Arkadiy KAZAZYAN on 01/07/2025.
//

import SwiftUI
internal import Combine
import OSLog

struct ContentView: View {

    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "PipBoy", category: "ContentView")
    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        // UI sizes are now dynamically scaled for different Apple Watch screen sizes using GeometryReader
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    Text("PIP-BOY 3000")
                        .pipboyText(size: 12 * geometry.size.width / 184.0) // Retro digital font
                        .multilineTextAlignment(.center)
                        .padding(.top, geometry.size.height * 0.01)
                        .padding(.trailing, 20 * geometry.size.width / 184.0)
                    HStack{
                        // Day of month (left)
                        Text(viewModel.dayOfMonth(from: viewModel.currentTime))
                            .pipboyText(size: 24 * geometry.size.width / 184.0)
                        Spacer()
                        Text(viewModel.monthOfDate(from: viewModel.currentTime))
                            .pipboyText(size: 24 * geometry.size.width / 184.0)
                        Spacer()
                        // Day of week (right)
                        Text(viewModel.dayOfWeek(from: viewModel.currentTime))
                            .pipboyText(size: 24 * geometry.size.width / 184.0)
                    }
                    .padding(.horizontal, geometry.size.width * 0.033)
                    .padding(.top, geometry.size.height * 0.016)

                    Image(uiImage: viewModel.frames[viewModel.currentFrameIndex])
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.55, height: geometry.size.height * 0.45) // Scaled for Apple Watch
                        .offset(y: geometry.size.height * 0.03)

                    Text(viewModel.timeString(from: viewModel.currentTime))
                        .pipboyText(size: 30 * geometry.size.width / 184.0) // Retro digital font
                        .multilineTextAlignment(.center)
                        .padding(.top, geometry.size.height * 0.01)

                }

                // Green digital time display
                HStack {
                    Text("DAY")
                        .pipboyText(size: 16 * geometry.size.width / 184.0, color: .black)
                        .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.08)
                        .background(.green)

                    Spacer()

                    Text("WEEK")
                        .pipboyText(size: 16 * geometry.size.width / 184.0, color: .black)
                        .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.08)
                        .background(.green)
                }
                .padding(.leading, geometry.size.width * 0.033)
                .offset(y: -geometry.size.height * 0.16)

                HStack {
                    Text(viewModel.heartRate)
                        .pipboyText(size: 16 * geometry.size.width / 184.0)

                    Spacer()

                    Text(viewModel.bloodOxygen)
                        .pipboyText(size: 16 * geometry.size.width / 184.0)
                }
                .padding(.leading, geometry.size.width * 0.033)
                .offset(y: -geometry.size.height * 0.05)

                HStack {
                    Text("BPM")
                        .pipboyText(size: 16 * geometry.size.width / 184.0, color: .black)
                        .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.08)
                        .background(.green)

                    Spacer()

                    HStack(spacing: 0) {
                        Text("O")
                            .pipboyText(size: 16 * geometry.size.width / 184.0, color: .black)
                            .padding(.leading, geometry.size.width * 0.033)
                        Text("2")
                            .pipboyText(size: 10 * geometry.size.width / 184.0, color: .black)
                            .offset(y: geometry.size.height * 0.02)
                            .padding(.trailing, geometry.size.width * 0.033)
                    }
                    .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.08)
                    .background(.green)
                }
                .padding(.leading, geometry.size.width * 0.033)
                .offset(y: geometry.size.height * 0.04)

                HStack {
                    Spacer()
                    Text(viewModel.batteryLevel)
                        .pipboyText(size: 16 * geometry.size.width / 184.0)
                }
                .offset(y: geometry.size.height * 0.15)
                .padding(.leading, geometry.size.width * 0.033)

                HStack {
                    Spacer()
                    Image(systemName: "minus.plus.batteryblock.exclamationmark.fill")
                        .resizable()
                        .scaledToFit()
                        .padding(3)
                        .foregroundColor(.black)
                        .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.08)
                        .background(.green)
                }
                .offset(y: geometry.size.height * 0.25)
                .padding(.leading, geometry.size.width * 0.033)
            }
            .onReceive(viewModel.frameTimer) { _ in
                viewModel.currentFrameIndex = (viewModel.currentFrameIndex + 1) % viewModel.frameCount
                logger.debug("Switching to frame \(viewModel.currentFrameIndex)")
            }
            .onReceive(viewModel.clockTimer) { _ in
                viewModel.currentTime = Date()
                logger.debug("Updating time: \(viewModel.timeString(from: viewModel.currentTime))") // Debug time
            }
            .onReceive(viewModel.updateTimer) { _ in
                Task {
                    await viewModel.fetchHeartRate()
                    await viewModel.fetchBloodOxygen()
                    viewModel.updateBatteryLevel()
                    logger.debug("Updating ...") // Debug time
                }
            }
            .onAppear {
                Task {
                    await viewModel.requestAuthorization()
                }
                viewModel.updateBatteryLevel()
            }
            .onChange(of: viewModel.isAuthorized) { _, isAuthorized in
                if !isAuthorized {
                    viewModel.healthError = "Enable HealthKit in Settings"
                    viewModel.heartRate = "--"
                } else {
                    viewModel.healthError = nil
                    Task {
                        await viewModel.fetchHeartRate()
                        await viewModel.fetchBloodOxygen()
                    }
                }
            }
        }
        .ignoresSafeArea() // Ensure full-screen to hide system time
    }
}

#Preview {
    ContentView()
}

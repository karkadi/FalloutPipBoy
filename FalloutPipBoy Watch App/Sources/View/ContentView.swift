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
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Text("PIP-BOY 3000")
                    .pipboyText(size: 12) // Retro digital font
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
                HStack{
                    // Day of month (left)
                    Text(viewModel.dayOfMonth(from: viewModel.currentTime))
                        .pipboyText(size: 24)
                    Spacer()
                    Text(viewModel.monthOfDate(from: viewModel.currentTime))
                        .pipboyText(size: 24)
                    Spacer()
                    // Day of week (right)
                    Text(viewModel.dayOfWeek(from: viewModel.currentTime))
                        .pipboyText(size: 24)
                }
                .padding(.horizontal, 6)
                .padding(.top, 4)

                Image(uiImage: viewModel.frames[viewModel.currentFrameIndex])
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 112) // Scaled for Apple Watch
                    .offset(y: 8)

                Text(viewModel.timeString(from: viewModel.currentTime))
                    .pipboyText(size: 30) // Retro digital font
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)

            }

            // Green digital time display
            HStack {
                Text("DAY")
                    .pipboyText(size: 20, color: .black)
                    .frame(width: 48, height: 20)
                    .background(.green)

                Spacer()

                Text("WEEK")
                    .pipboyText(size: 20, color: .black)
                    .frame(width: 48, height: 20)
                    .background(.green)
            }
            .padding(.leading,6)
            .offset(y: -40)

            HStack {
                Text(viewModel.heartRate)
                    .pipboyText(size: 20)

                Spacer()

                Text(viewModel.bloodOxygen)
                    .pipboyText(size: 20)
            }
            .padding(.leading,6)
            .offset(y: -10)

            HStack {
                Text("BPM")
                    .pipboyText(size: 20, color: .black)
                    .frame(width: 48, height: 20)
                    .background(.green)

                Spacer()

                HStack(spacing: 0) {
                    Text("O")
                        .pipboyText(size: 20, color: .black)
                        .padding(.leading,6)
                    Text("2")
                        .pipboyText(size: 14, color: .black)
                        .offset(y: 4)
                        .padding(.trailing,6)
                }
                .frame(width: 48, height: 20)
                .background(.green)
            }
            .padding(.leading,6)
            .offset(y: 28)

        }
        .ignoresSafeArea() // Ensure full-screen to hide system time
        .onReceive(viewModel.frameTimer) { _ in
            viewModel.currentFrameIndex = (viewModel.currentFrameIndex + 1) % viewModel.frameCount
            logger.debug("Switching to frame \(viewModel.currentFrameIndex)")
        }
        .onReceive(viewModel.clockTimer) { _ in
            viewModel.currentTime = Date()
            logger.debug("Updating time: \(viewModel.timeString(from: viewModel.currentTime))") // Debug time
        }
        .onReceive(viewModel.healthTimer) { _ in
            Task {
                await viewModel.fetchHeartRate()
                await viewModel.fetchBloodOxygen()
                logger.debug("Updating time: \(viewModel.timeString(from: viewModel.currentTime))") // Debug time
            }
        }
        .onAppear {
            Task {
                await viewModel.requestAuthorization()
            }
        }
        .onChange(of: viewModel.isAuthorized) { _, isAuthorized in
            if !isAuthorized {
                viewModel.healthError = "Enable HealthKit in Settings"
                viewModel.heartRate = "--"
            } else {
                viewModel.healthError = nil
                Task {
                    await viewModel.fetchHeartRate()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

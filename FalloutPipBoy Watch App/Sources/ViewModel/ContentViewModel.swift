// ContentViewModel.swift
// FalloutPipBoy Watch App
// Created by refactoring ContentView

import SwiftUI
internal import Combine
import os

@MainActor
class ContentViewModel: ObservableObject {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "pipboy", category: "ContentViewModel")

    @Published var currentFrameIndex = 0
    @Published var currentTime = Date()
    @Published var heartRate: String = "--"
    @Published var healthError: String? = nil
    @Published var bloodOxygen: String = "--%"
    @Published var batteryLevel: String = "--%"
    @Published var isAuthorized: Bool = false

    @Published var frameTimer: Publishers.Autoconnect<Timer.TimerPublisher>
    @Published var clockTimer: Publishers.Autoconnect<Timer.TimerPublisher>
    @Published var updateTimer: Publishers.Autoconnect<Timer.TimerPublisher>

    let frames: [UIImage]
    let frameCount = 21
    let frameWidth: CGFloat = 242
    let frameHeight: CGFloat = 337
    let frameDuration: TimeInterval = 0.1

    private let healthManager = HealthManager()
    private var cancellables = Set<AnyCancellable>()

    init() {
        self.frames = ContentViewModel.createSpriteFrames(imageName: "pipBoy",
                                                          frameCount: frameCount,
                                                          frameWidth: frameWidth,
                                                          frameHeight: frameHeight)
        self.frameTimer = Timer.publish(every: frameDuration, on: .main, in: .common).autoconnect()
        self.clockTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        self.updateTimer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
        // Sync isAuthorized with HealthManager
        healthManager.$isAuthorized
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
                self?.isAuthorized = value
            }
            .store(in: &cancellables)
    }

    // Format time as HH:mm:ss
    func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }

    func dayOfMonth(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddd"
        return formatter.string(from: date)
    }

    func monthOfDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        return formatter.string(from: date)
    }

    func dayOfWeek(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }

    func fetchHeartRate() async {
        do {
            let rate = try await healthManager.getRecentHeartRate()
            heartRate = String(format: "%03.0f", rate)
            healthError = nil
            logger.debug("Heart rate updated: \(self.heartRate)")
        } catch {
            logger.error("Error fetching heart rate: \(error.localizedDescription)")
            heartRate = "--"
            healthError = "Health data unavailable"
        }
    }

    func fetchBloodOxygen() async {
        do {
            let spO2 = try await healthManager.getRecentBloodOxygen()
            bloodOxygen = String(format: "%.0f%%", spO2 * 100)
            healthError = nil
            logger.debug("Blood oxygen updated: \(self.bloodOxygen)")
        } catch {
            logger.error("Error fetching blood oxygen: \(error.localizedDescription)")
            bloodOxygen = "--%"
            healthError = "Health data unavailable"
        }
    }

    func requestAuthorization() async {
        await healthManager.requestAuthorization()
    }

    func updateBatteryLevel() {
        WKInterfaceDevice.current().isBatteryMonitoringEnabled = true
        let level = WKInterfaceDevice.current().batteryLevel
        WKInterfaceDevice.current().isBatteryMonitoringEnabled = false
        if level >= 0 {
            batteryLevel = String(format: "%03.0f%%", level * 100) // 3 digits with leading zeros
            logger.debug("Battery level updated: \(self.batteryLevel)") // Debug battery
        } else {
            batteryLevel = "--%"
            logger.error("Battery level unavailable")
        }
    }

    static func createSpriteFrames(imageName: String,
                                   frameCount: Int,
                                   frameWidth: CGFloat ,
                                   frameHeight: CGFloat ) -> [UIImage] {
        guard let spriteSheet = UIImage(named: imageName) else {
            Logger(subsystem: Bundle.main.bundleIdentifier ?? "pipboy", category: "ContentViewModel")
                .error("Error: Could not load sprite sheet named '\(imageName)'")
            return [UIImage()]
        }
        let sheetWidth = spriteSheet.size.width
        let sheetHeight = spriteSheet.size.height
        Logger(subsystem: Bundle.main.bundleIdentifier ?? "pipboy", category: "ContentViewModel")
            .debug("Sprite sheet size: \(sheetWidth)x\(sheetHeight)")
        let expectedHeight = frameHeight * CGFloat(frameCount)
        guard sheetWidth >= frameWidth, sheetHeight >= expectedHeight else {
            Logger(subsystem: Bundle.main.bundleIdentifier ?? "pipboy", category: "ContentViewModel")
                .error("Error: Sprite sheet dimensions (\(sheetWidth)x\(sheetHeight)) are smaller than expected (\(frameWidth)x\(expectedHeight))")
            return [spriteSheet]
        }
        var frames: [UIImage] = []
        for i in 0..<frameCount {
            let yPosition = CGFloat(i) * frameHeight
            let frameRect = CGRect(x: 0, y: yPosition, width: frameWidth, height: frameHeight)
            if let cgImage = spriteSheet.cgImage?.cropping(to: frameRect) {
                let frameImage = UIImage(cgImage: cgImage)
                frames.append(frameImage)
            } else {
                Logger(subsystem: Bundle.main.bundleIdentifier ?? "pipboy", category: "ContentViewModel")
                    .error("Error: Failed to crop frame \(i) at \(frameRect.width)x\(frameRect.height)")
            }
        }
        Logger(subsystem: Bundle.main.bundleIdentifier ?? "pipboy", category: "ContentViewModel")
            .debug("Extracted \(frames.count) frames")
        return frames.isEmpty ? [spriteSheet] : frames
    }
}

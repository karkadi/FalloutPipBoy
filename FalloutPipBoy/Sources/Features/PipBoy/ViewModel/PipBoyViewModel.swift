//
// PipBoyViewModel.swift
//  FalloutPipBoy
//
//  Created by Arkadiy KAZAZYAN on 25/08/2025.
//

import SwiftUI
import OSLog
import Observation
import WatchKit

@MainActor
@Observable
final class PipBoyViewModel {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "pipboy", category: "PipBoyViewModel")
    
    var currentFrameIndex = 0
    var currentTime = Date()
    var heartRate: String = "--"
    var healthError: String?
    var bloodOxygen: String = "--%"
    var batteryLevel: String = "--%"
    var isAuthorized: Bool = false
    
    // Timer tasks for cancellation
    private var frameTimerTask: Task<Void, Never>?
    private var clockTimerTask: Task<Void, Never>?
    private var updateTimerTask: Task<Void, Never>?
    
    let frames: [UIImage]
    let frameCount = 21
    let frameWidth: CGFloat = 242
    let frameHeight: CGFloat = 337
    let frameDuration: TimeInterval = 0.1
    
    private let healthManager = HealthManager()
    
    init() {
        self.frames = PipBoyViewModel.createSpriteFrames(
            imageName: "pipBoy",
            frameCount: frameCount,
            frameWidth: frameWidth,
            frameHeight: frameHeight
        )
        
        // Observe health manager authorization changes
        Task { @MainActor in
            for await _ in NotificationCenter.default.notifications(named: .healthAuthorizationChanged) {
                self.isAuthorized = healthManager.isAuthorized
            }
        }
        
        startTimers()
    }
    
    @MainActor
    deinit {
        cancelTimers()
    }
    
    private func startTimers() {
        // Frame timer (0.1 second interval)
        frameTimerTask = Task { [weak self] in
            guard let self = self else { return }
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: UInt64(self.frameDuration * 1_000_000_000))
                await MainActor.run {
                    self.currentFrameIndex = (self.currentFrameIndex + 1) % self.frameCount
                }
            }
        }
        
        // Clock timer (1 second interval)
        clockTimerTask = Task { [weak self] in
            guard let self = self else { return }
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                await MainActor.run {
                    self.currentTime = Date()
                }
            }
        }
        
        // Update timer (10 second interval)
        updateTimerTask = Task { [weak self] in
            guard let self = self else { return }
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 10_000_000_000)
                await self.performUpdate()
            }
        }
    }
    
    private func cancelTimers() {
        frameTimerTask?.cancel()
        clockTimerTask?.cancel()
        updateTimerTask?.cancel()
        frameTimerTask = nil
        clockTimerTask = nil
        updateTimerTask = nil
    }
    
    private func performUpdate() async {
        await fetchHeartRate()
        await fetchBloodOxygen()
        updateBatteryLevel()
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
        isAuthorized = healthManager.isAuthorized
    }
    
    func updateBatteryLevel() {
        WKInterfaceDevice.current().isBatteryMonitoringEnabled = true
        let level = WKInterfaceDevice.current().batteryLevel
        WKInterfaceDevice.current().isBatteryMonitoringEnabled = false
        if level >= 0 {
            batteryLevel = String(format: "%03.0f%%", level * 100)
            logger.debug("Battery level updated: \(self.batteryLevel)")
        } else {
            batteryLevel = "--%"
            logger.error("Battery level unavailable")
        }
    }
    
    static func createSpriteFrames(imageName: String,
                                   frameCount: Int,
                                   frameWidth: CGFloat,
                                   frameHeight: CGFloat ) -> [UIImage] {
        guard let spriteSheet = UIImage(named: imageName) else {
            Logger(subsystem: Bundle.main.bundleIdentifier ?? "pipboy", category: "PipBoyViewModel")
                .error("Error: Could not load sprite sheet named '\(imageName)'")
            return [UIImage()]
        }
        let sheetWidth = spriteSheet.size.width
        let sheetHeight = spriteSheet.size.height
        Logger(subsystem: Bundle.main.bundleIdentifier ?? "pipboy", category: "PipBoyViewModel")
            .debug("Sprite sheet size: \(sheetWidth)x\(sheetHeight)")
        let expectedHeight = frameHeight * CGFloat(frameCount)
        guard sheetWidth >= frameWidth, sheetHeight >= expectedHeight else {
            Logger(subsystem: Bundle.main.bundleIdentifier ?? "pipboy", category: "PipBoyViewModel")
                .error("Error: Sprite sheet dimensions (\(sheetWidth)x\(sheetHeight)) are smaller than expected (\(frameWidth)x\(expectedHeight))")
            return [spriteSheet]
        }
        var frames: [UIImage] = []
        for index in 0..<frameCount {
            let yPosition = CGFloat(index) * frameHeight
            let frameRect = CGRect(x: 0, y: yPosition, width: frameWidth, height: frameHeight)
            if let cgImage = spriteSheet.cgImage?.cropping(to: frameRect) {
                let frameImage = UIImage(cgImage: cgImage)
                frames.append(frameImage)
            } else {
                Logger(subsystem: Bundle.main.bundleIdentifier ?? "pipboy", category: "PipBoyViewModel")
                    .error("Error: Failed to crop frame \(index) at \(frameRect.width)x\(frameRect.height)")
            }
        }
        Logger(subsystem: Bundle.main.bundleIdentifier ?? "pipboy", category: "PipBoyViewModel")
            .debug("Extracted \(frames.count) frames")
        return frames.isEmpty ? [spriteSheet] : frames
    }
}

// MARK: - Notification Extension
extension Notification.Name {
    static let healthAuthorizationChanged = Notification.Name("healthAuthorizationChanged")
}

// MARK: - HealthManager Extension for Observation
extension HealthManager {
    func observeAuthorizationChanges() {
        NotificationCenter.default.post(name: .healthAuthorizationChanged, object: nil)
    }
}

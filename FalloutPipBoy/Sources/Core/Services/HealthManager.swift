//
//  HealthManager.swift
//  FalloutPipBoy
//
//  Created by Arkadiy KAZAZYAN on 01/07/2025.
//

import Foundation
import HealthKit
import OSLog
import Observation

/// `HealthManager` is a utility class for interacting with HealthKit on Apple platforms.
///
/// This class manages authorization and reads heart rate and blood oxygen data from HealthKit.
/// It requires user authorization and uses the `@Observable` macro for SwiftUI observation.
///
/// ## Capabilities
/// - Requests HealthKit authorization for reading heart rate and blood oxygen data
/// - Provides methods to fetch the most recent heart rate and blood oxygen saturation sample
/// - Publishes the HealthKit authorization status for UI observation
/// - Logs key events and errors using the unified logging system (`OSLog`)
///
/// ## Usage
/// 1. Call `requestAuthorization()` to prompt the user for HealthKit access.
/// 2. After authorization, use `getRecentHeartRate()` and `getRecentBloodOxygen()` to fetch data.
/// 3. Observe `isAuthorized` to update the UI as authorization status changes.
///
/// ## Requirements
/// - HealthKit capability must be enabled in the app target.
/// - The app must run on supported hardware with HealthKit sensors and permissions.
///
/// ## Example
/// ```swift
/// @Environment(HealthManager.self) private var healthManager
/// await healthManager.requestAuthorization()
/// if healthManager.isAuthorized {
///     let heartRate = try await healthManager.getRecentHeartRate()
///     let spO2 = try await healthManager.getRecentBloodOxygen()
/// }
/// ```
@Observable
class HealthManager {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "PipBoy", category: "HealthManager")
    private let healthStore = HKHealthStore()
    var isAuthorized: Bool = false

    init() {}

    func requestAuthorization() async {
        guard HKHealthStore.isHealthDataAvailable() else {
            logger.debug("HealthKit not available on this device")
            return
        }

        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let oxygenSaturation = HKQuantityType.quantityType(forIdentifier: .oxygenSaturation)!

        do {
            try await healthStore.requestAuthorization(toShare: [], read: [heartRateType, oxygenSaturation])
            isAuthorized = true
            logger.debug("HealthKit authorization granted")
        } catch {
            logger.debug("HealthKit authorization error: \(error)")
            isAuthorized = false
        }
    }

    func getRecentHeartRate() async throws -> Double {
        guard isAuthorized else {
            throw HealthError.notAuthorized
        }

        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let startDate = Calendar.current.date(byAdding: .hour, value: -1, to: Date())!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)

        let samples = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample]?, Error>) in
            let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume(returning: samples)
            }
            healthStore.execute(query)
        }

        guard let heartRateSample = samples?.first as? HKQuantitySample else {
            throw HealthError.noData
        }

        let heartRate = heartRateSample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
        logger.debug("Retrieved heart rate: \(heartRate)")
        return heartRate
    }

    func getRecentBloodOxygen() async throws -> Double {
        guard isAuthorized else {
            throw HealthError.notAuthorized
        }

        guard HKHealthStore.isHealthDataAvailable() else {
            throw HealthError.notSupported
        }

        let bloodOxygenType = HKQuantityType.quantityType(forIdentifier: .oxygenSaturation)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let startDate = Calendar.current.date(byAdding: .hour, value: -1, to: Date())!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date())

        let samples = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample]?, Error>) in
            let query = HKSampleQuery(sampleType: bloodOxygenType, predicate: predicate, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume(returning: samples)
            }
            healthStore.execute(query)
        }

        guard let sample = samples?.first as? HKQuantitySample else {
            throw HealthError.noData
        }

        let spO2 = sample.quantity.doubleValue(for: HKUnit.percent())
        logger.debug("Retrieved blood oxygen: \(spO2)")
        return spO2
    }
}

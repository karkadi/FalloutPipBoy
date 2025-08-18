//
//  HealthManager.swift
//  FalloutPipBoy
//
//  Created by Arkadiy KAZAZYAN on 01/07/2025.
//

import Foundation
import HealthKit
internal import Combine
import OSLog

class HealthManager: NSObject, ObservableObject {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "PipBoy", category: "HealthManager")
    private let healthStore = HKHealthStore()
    @Published var isAuthorized: Bool = false

    override init() {
        super.init()
    }

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
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "HealthKit not authorized"])
        }

        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

        let startDate = Calendar.current.date(byAdding: .hour, value: -1, to: Date())!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, error in
                if let error = error {
                    self.logger.debug("Heart rate query error: \(error)")
                    continuation.resume(throwing: error)
                    return
                }
                if let heartRateSample = samples?.first as? HKQuantitySample {
                    let heartRate = heartRateSample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
                    continuation.resume(returning: heartRate)
                } else {
                    continuation.resume(throwing: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No heart rate data"]))
                }
            }
            healthStore.execute(query)
        }
    }

    func getRecentBloodOxygen() async throws -> Double {
        guard isAuthorized else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "HealthKit not authorized"])
        }

        guard HKHealthStore.isHealthDataAvailable() else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Blood oxygen not supported on this device"])
        }

        let bloodOxygenType = HKQuantityType.quantityType(forIdentifier: .oxygenSaturation)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let startDate = Calendar.current.date(byAdding: .hour, value: -1, to: Date())!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date())

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(sampleType: bloodOxygenType, predicate: predicate, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, error in
                if let error = error {
                    self.logger.debug("Blood oxygen query error: \(error)")
                    continuation.resume(throwing: error)
                    return
                }

                if let sample = samples?.first as? HKQuantitySample {
                    let spO2 = sample.quantity.doubleValue(for: HKUnit.percent())
                    continuation.resume(returning: spO2)
                } else {
                    continuation.resume(throwing: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No blood oxygen data"]))
                }
            }
            healthStore.execute(query)
        }
    }

}


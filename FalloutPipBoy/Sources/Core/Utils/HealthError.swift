//
//  HealthError.swift
//  FalloutPipBoy
//
//  Created by Arkadiy KAZAZYAN on 18/03/2026.
//

import Foundation

// MARK: - Error Handling
enum HealthError: LocalizedError {
    case notAuthorized
    case notSupported
    case noData

    var errorDescription: String? {
        switch self {
        case .notAuthorized:
            return "HealthKit not authorized"
        case .notSupported:
            return "Blood oxygen not supported on this device"
        case .noData:
            return "No health data available"
        }
    }
}

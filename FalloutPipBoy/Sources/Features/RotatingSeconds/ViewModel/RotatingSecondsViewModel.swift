//
//  RotatingSecondsViewModel.swift
//  FalloutPipBoy
//
//  Created by Arkadiy KAZAZYAN on 17/08/2025.
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class RotatingSecondsViewModel {
    var now: Date = Date()
    var preciseSecond: Double = 0
    var secondFraction: Int = 0
    var nanosec: Int = 0
    var minutes: Int = 0
    var hour: Int = 0
    
    private var timerTask: Task<Void, Never>?
    
    init() {
        timerTask = Task { @MainActor in
            while !Task.isCancelled {
                let date = Date()
                self.now = date
                let calendar = Calendar.current
                self.secondFraction = calendar.component(.second, from: date)
                self.nanosec = calendar.component(.nanosecond, from: date)
                self.preciseSecond = Double(self.secondFraction) + Double(self.nanosec) / 1_000_000_000
                self.minutes = calendar.component(.minute, from: date)
                self.hour = calendar.component(.hour, from: date)
                
                try? await Task.sleep(nanoseconds: 16_666_667) // ~60fps
            }
        }
    }
    
    @MainActor
    deinit {
        timerTask?.cancel()
    }
}

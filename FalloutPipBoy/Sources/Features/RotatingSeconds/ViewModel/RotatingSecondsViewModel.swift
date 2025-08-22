//
//  RotatingSecondsViewModel.swift
//  FalloutPipBoy
//
//  Created by Arkadiy KAZAZYAN on 17/08/2025.
//

internal import Combine
import Foundation

final class RotatingSecondsViewModel: ObservableObject {
    @Published var now: Date = Date()
    @Published var preciseSecond: Double = 0
    @Published var secondFraction: Int = 0
    @Published var nanosec: Int = 0
    @Published var minutes: Int = 0
    @Published var hour: Int = 0

    private var timer: AnyCancellable?

    init() {
        timer = Timer.publish(every: 1.0/60.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] date in
                guard let self = self else { return }
                self.now = date
                let calendar = Calendar.current
                self.secondFraction = calendar.component(.second, from: date)
                self.nanosec = calendar.component(.nanosecond, from: date)
                self.preciseSecond = Double(self.secondFraction) + Double(self.nanosec) / 1_000_000_000
                self.minutes = calendar.component(.minute, from: date)
                self.hour = calendar.component(.hour, from: date)
            }
    }

    deinit {
        timer?.cancel()
    }
}

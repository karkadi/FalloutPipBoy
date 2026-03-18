//
//  TimeCircuitsViewModel.swift
//  FalloutPipBoy
//
//  Created by Arkadiy KAZAZYAN on 21/08/2025.
//

import Foundation

@MainActor
@Observable
final class TimeCircuitsViewModel {
    var monthYear: String = "OCT 26 1985"
    var month: String = "OCT"
    
    var dayOfWeek: String = "MONDAY"
    var time: String = "01:21:00"
    var destinationTime: String = "NOV 05 1955"
    var presentTime: String = "OCT 26 1985"
    var lastTimeDeparted: String = "-- -- ----"
    
    var dateComponents: DateComponents = DateComponents()
    
    private var timerTask: Task<Void, Never>?
    private var animationTask: Task<Void, Never>?
    private var currentDate = Date()
    private var isAnimating = false
    private var animationStep = 0
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    private let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter
    }()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
    
    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    
    init() {
        updateDisplay()
    }
    
    @MainActor
    deinit {
        timerTask?.cancel()
        animationTask?.cancel()
    }
    
    func startUpdates() {
        guard timerTask == nil else { return }
        
        timerTask = Task { @MainActor in
            while !Task.isCancelled {
                // Update date and display
                self.currentDate = Date()
                self.updateDisplay()
                
                // Wait for 1 second
                try? await Task.sleep(nanoseconds: 1_000_000_000)
            }
        }
    }
    
    func stopUpdates() {
        timerTask?.cancel()
        timerTask = nil
        animationTask?.cancel()
        animationTask = nil
    }
    
    private func updateDisplay() {
        if !isAnimating {
            monthYear = dateFormatter.string(from: currentDate).uppercased()
            month = monthFormatter.string(from: currentDate).uppercased()
            dayOfWeek = dayFormatter.string(from: currentDate).uppercased()
            time = timeFormatter.string(from: currentDate)
            
            let calendar = Calendar.current
            dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDate)
        }
    }
    
    func toggleDestinationTime() {
        isAnimating = true
        animateToRandomDate()
    }
    
    func togglePresentTime() {
        isAnimating = true
        animateToCurrentDate()
    }
    
    func toggleDepartureTime() {
        lastTimeDeparted = monthYear
        // Add departure sound effect here if needed
    }
    
    private func animateToRandomDate() {
        animationStep = 0
        startDateAnimation(targetDate: generateRandomDate())
    }
    
    private func animateToCurrentDate() {
        animationStep = 0
        startDateAnimation(targetDate: Date())
    }
    
    private func startDateAnimation(targetDate: Date) {
        // Cancel any existing animation
        animationTask?.cancel()
        
        animationTask = Task { @MainActor in
            let totalSteps = 20
            
            for step in 0...totalSteps {
                guard !Task.isCancelled else { break }
                animationStep = step
                if step >= totalSteps {
                    // Final step - set actual values
                    self.monthYear = self.dateFormatter.string(from: targetDate).uppercased()
                    self.dayOfWeek = self.dayFormatter.string(from: targetDate).uppercased()
                    self.time = self.timeFormatter.string(from: targetDate)
                    self.isAnimating = false
                    break
                }
                
                // Animate digits
                self.monthYear = self.animateString(self.dateFormatter.string(from: targetDate).uppercased())
                self.dayOfWeek = self.animateString(self.dayFormatter.string(from: targetDate).uppercased())
                self.time = self.animateString(self.timeFormatter.string(from: targetDate))
                
                // Wait for 0.1 seconds between animation steps
                try? await Task.sleep(nanoseconds: 100_000_000)
            }
        }
    }
    
    private func animateString(_ target: String) -> String {
        var result = ""
        for char in target {
            if char == " " || char == ":" {
                result.append(char)
            } else {
                let randomDigit = String(( Int(char.asciiValue ?? 0) + animationStep) % 10)
                result.append(randomDigit)
            }
        }
        return result
    }
    
    private func generateRandomDate() -> Date {
        let randomYear = Int.random(in: 1950...2050)
        let randomMonth = Int.random(in: 1...12)
        let randomDay = Int.random(in: 1...28) // Safe day for all months
        
        var components = DateComponents()
        components.year = randomYear
        components.month = randomMonth
        components.day = randomDay
        components.hour = Int.random(in: 0...23)
        components.minute = Int.random(in: 0...59)
        components.second = Int.random(in: 0...59)
        
        return Calendar.current.date(from: components) ?? Date()
    }
}

//
//  TimeCircuitsViewModel.swift
//  FalloutPipBoy
//
//  Created by Arkadiy KAZAZYAN on 21/08/2025.
//

import Foundation
internal import Combine

class TimeCircuitsViewModel: ObservableObject {
    @Published var monthYear: String = "OCT 26 1985"
    @Published var month: String = "OCT"
    
    @Published var dayOfWeek: String = "MONDAY"
    @Published var time: String = "01:21:00"
    @Published var destinationTime: String = "NOV 05 1955"
    @Published var presentTime: String = "OCT 26 1985"
    @Published var lastTimeDeparted: String = "-- -- ----"
    
    @Published var dateComponents: DateComponents = DateComponents()
    
    private var timer: Timer?
    private var currentDate = Date()
    private var isAnimating = false
    private var animationStep = 0
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yyyy"
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
    
    func startUpdates() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.currentDate = Date()
            self?.updateDisplay()
        }
    }
    
    func stopUpdates() {
        timer?.invalidate()
        timer = nil
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
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            if self.animationStep >= 20 {
                timer.invalidate()
                self.isAnimating = false
                self.monthYear = self.dateFormatter.string(from: targetDate).uppercased()
                self.dayOfWeek = self.dayFormatter.string(from: targetDate).uppercased()
                self.time = self.timeFormatter.string(from: targetDate)
                return
            }
            
            // Animate digits
            self.monthYear = self.animateString(self.dateFormatter.string(from: targetDate).uppercased())
            self.dayOfWeek = self.animateString(self.dayFormatter.string(from: targetDate).uppercased())
            self.time = self.animateString(self.timeFormatter.string(from: targetDate))
            
            self.animationStep += 1
        }
    }
    
    private func animateString(_ target: String) -> String {
        var result = ""
        for char in target {
            if char == " " || char == ":" {
                result.append(char)
            } else {
                let randomDigit = String(Int.random(in: 0...9))
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

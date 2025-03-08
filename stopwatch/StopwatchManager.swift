//
//  StopwatchManager.swift - Handles the stopwatch functionality
//  stopwatch
//
//  Created by Joshua Coronado on 3/7/25.
//
import Foundation
import Combine

class StopwatchManager: ObservableObject {
    @Published var elapsedTime: TimeInterval = 0
    @Published var formattedElapsedTime: String = "00:00.00"
    @Published var isRunning: Bool = false
    @Published var laps: [String] = []
    
    private var timer: Timer?
    private var startTime: Date?
    private var accumulatedTime: TimeInterval = 0
    
    private let formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    // MARK: - Public Methods
    
    func toggleRunning() {
        isRunning ? stop() : start()
    }
    
    func start() {
        if !isRunning {
            isRunning = true
            startTime = Date()
            
            // Use a high-precision timer for smoother updates
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
                self?.updateElapsedTime()
            }
            
            // Make sure the timer fires even during tracking events like scrolling
            RunLoop.current.add(timer!, forMode: .common)
        }
    }
    
    func stop() {
        if isRunning {
            isRunning = false
            
            // Save accumulated time when stopped
            if let startTime = startTime {
                accumulatedTime += Date().timeIntervalSince(startTime)
            }
            
            timer?.invalidate()
            timer = nil
            startTime = nil
        }
    }
    
    func reset() {
        stop()
        elapsedTime = 0
        accumulatedTime = 0
        updateFormattedTime()
        laps.removeAll()
    }
    
    func recordLap() {
        if isRunning || elapsedTime > 0 {
            laps.insert(formattedElapsedTime, at: 0)
        }
    }
    
    // MARK: - Private Methods
    
    private func updateElapsedTime() {
        if let startTime = startTime {
            elapsedTime = accumulatedTime + Date().timeIntervalSince(startTime)
            updateFormattedTime()
        }
    }
    
    private func updateFormattedTime() {
        // For more precision, we'll format the time manually instead of using DateComponentsFormatter
        let totalSeconds = Int(elapsedTime)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        let hundredths = Int((elapsedTime.truncatingRemainder(dividingBy: 1)) * 100)
        
        formattedElapsedTime = String(format: "%02d:%02d.%02d", minutes, seconds, hundredths)
    }
}


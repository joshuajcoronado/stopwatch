//
//  ContentView.swift
//  stopwatch
//
//  Created by Joshua Coronado on 3/7/25.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var stopwatchManager = StopwatchManager()
    @State private var isFullscreen = false
    @State private var spacebarPressed = false // Track spacebar press animation
    
    var body: some View {
        ZStack {
            // Background with tap gesture to toggle stopwatch
            Rectangle()
                .fill(Color.black)
                .edgesIgnoringSafeArea(.all)
                .contentShape(Rectangle()) // Make entire area tappable
                .onTapGesture {
                    handleTapAction()
                }
                // Add a second gesture recognizer for better responsiveness
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onEnded { _ in
                            handleTapAction()
                        }
                )
            
            GeometryReader { geometry in
                VStack(spacing: geometry.size.height * 0.05) {
                // Stopwatch Display with reactive sizing
                GeometryReader { geometry in
                    Text(stopwatchManager.formattedElapsedTime)
                        .font(.system(
                            size: min(geometry.size.width * 0.25, geometry.size.height * 0.5),
                            weight: .thin,
                            design: .monospaced
                        ))
                        .foregroundColor(.white)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                // Controls
                let buttonSize = min(geometry.size.width * 0.1, geometry.size.height * 0.15)
                let primaryButtonSize = buttonSize * 1.25
                let iconSize = buttonSize * 0.4
                let primaryIconSize = iconSize * 1.25
                
                HStack(spacing: geometry.size.width * 0.05) {
                    // Reset Button
                    VStack(spacing: 5) {
                        Button(action: stopwatchManager.reset) {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(size: iconSize))
                                .foregroundColor(.white)
                                .frame(width: buttonSize, height: buttonSize)
                                .background(Color.gray.opacity(0.3))
                                .clipShape(Circle())
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Text("R")
                            .font(.system(size: min(geometry.size.width * 0.012, 10), weight: .bold))
                            .foregroundColor(.gray)
                            .help("Press R to reset the stopwatch")
                    }
                    
                    // Start/Stop Button
                    VStack(spacing: 5) {
                        Button(action: {
                            handleTapAction()
                        }) {
                            Image(systemName: stopwatchManager.isRunning ? "pause.fill" : "play.fill")
                                .font(.system(size: primaryIconSize))
                                .foregroundColor(.white)
                                .frame(width: primaryButtonSize, height: primaryButtonSize)
                                .background(
                                    stopwatchManager.isRunning
                                    ? Color.red.opacity(spacebarPressed ? 0.9 : 0.7)
                                    : Color.green.opacity(spacebarPressed ? 0.9 : 0.7)
                                )
                                .scaleEffect(spacebarPressed ? 1.1 : 1.0)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(spacebarPressed ? 0.6 : 0), lineWidth: 3)
                                        .scaleEffect(spacebarPressed ? 1.2 : 1.0)
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Text("SPACE")
                            .font(.system(size: min(geometry.size.width * 0.012, 10), weight: .bold))
                            .foregroundColor(.gray)
                            .help("Press SPACE to start/stop the stopwatch")
                    }
                    
                    // Lap Button
                    VStack(spacing: 5) {
                        Button(action: stopwatchManager.recordLap) {
                            Image(systemName: "flag.fill")
                                .font(.system(size: iconSize))
                                .foregroundColor(.white)
                                .frame(width: buttonSize, height: buttonSize)
                                .background(Color.blue.opacity(0.3))
                                .clipShape(Circle())
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Text("L")
                            .font(.system(size: min(geometry.size.width * 0.012, 10), weight: .bold))
                            .foregroundColor(.gray)
                            .help("Press L to record a lap")
                    }
                }
                .padding(.vertical, geometry.size.height * 0.03)
                
                // Laps Display
                if !stopwatchManager.laps.isEmpty {
                    ScrollView {
                        VStack(alignment: .leading, spacing: geometry.size.height * 0.015) {
                            Text("Laps")
                                .font(.system(size: min(geometry.size.width * 0.02, 16), weight: .bold))
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                            
                            ForEach(Array(stopwatchManager.laps.enumerated()), id: \.offset) { index, lap in
                                HStack {
                                    Text("Lap \(stopwatchManager.laps.count - index)")
                                        .font(.system(size: min(geometry.size.width * 0.018, 14), design: .monospaced))
                                        .foregroundColor(.gray)
                                    
                                    Spacer()
                                    
                                    Text(lap)
                                        .font(.system(size: min(geometry.size.width * 0.018, 14), design: .monospaced))
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding()
                    }
                    .frame(maxHeight: geometry.size.height * 0.3)
                }
                
                Spacer()
                
                // Fullscreen button and keyboard shortcut hint
                HStack {
                    Spacer()
                    
                    Button(action: toggleFullscreen) {
                        VStack(spacing: 5) {
                            Image(systemName: isFullscreen ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right")
                                .font(.system(size: min(geometry.size.width * 0.018, 16)))
                                .foregroundColor(.white)
                                
                            Text("⌘F")
                                .font(.system(size: min(geometry.size.width * 0.012, 10), weight: .bold))
                                .foregroundColor(.gray)
                                .help("Press Command+F to toggle fullscreen")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                }
            }
            .padding()
            }
        }
        .onAppear {
            // Set up notification observers for keyboard shortcuts
            NotificationCenter.default.addObserver(forName: NSNotification.Name("ToggleStopwatch"), object: nil, queue: .main) { _ in
                handleTapAction()
            }
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name("ResetStopwatch"), object: nil, queue: .main) { _ in
                stopwatchManager.reset()
            }
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name("RecordLap"), object: nil, queue: .main) { _ in
                stopwatchManager.recordLap()
            }
        }
        .onDisappear {
            // Remove observers when view disappears
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    private func toggleFullscreen() {
        if let window = (NSApp.delegate as? AppDelegate)?.window {
            window.toggleFullScreen(nil)
            isFullscreen.toggle()
        }
    }
    
    // Centralized handling of tap actions
    private func handleTapAction() {
        // Trigger visual space bar animation
        withAnimation(.easeInOut(duration: 0.1)) {
            spacebarPressed = true
        }
        
        stopwatchManager.toggleRunning()
        
        // Reset animation after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.easeInOut(duration: 0.1)) {
                self.spacebarPressed = false
            }
        }
    }
}

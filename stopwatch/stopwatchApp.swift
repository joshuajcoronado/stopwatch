//
//  stopwatchApp.swift
//  stopwatch
//
//  Created by Joshua Coronado on 3/7/25.
//
import SwiftUI

@main
struct StopwatchApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // Instead of closing the window, we'll hide it and ensure our AppDelegate window is front
                    if let window = NSApplication.shared.windows.first {
                        window.orderOut(nil)
                    }
                    // Only try to access delegate window if appDelegate is initialized
                    if appDelegate.window != nil {
                        appDelegate.window?.makeKeyAndOrderFront(nil)
                    }
                }
        }
        .commands {
            CommandGroup(after: .appSettings) {
                Button("Toggle Fullscreen") {
                    appDelegate.window?.toggleFullScreen(nil)
                }
                .keyboardShortcut("f", modifiers: [.command])
                
                Button("Start/Stop Stopwatch") {
                    NotificationCenter.default.post(name: NSNotification.Name("ToggleStopwatch"), object: nil)
                }
                .keyboardShortcut(.space, modifiers: [])
                
                Button("Reset Stopwatch") {
                    NotificationCenter.default.post(name: NSNotification.Name("ResetStopwatch"), object: nil)
                }
                .keyboardShortcut("r", modifiers: [])
                
                Button("Record Lap") {
                    NotificationCenter.default.post(name: NSNotification.Name("RecordLap"), object: nil)
                }
                .keyboardShortcut("l", modifiers: [])
            }
        }
    }
}

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
        }
        .commands {
            CommandGroup(after: .appSettings) {
                Button("Toggle Fullscreen") {
                    if let window = NSApplication.shared.windows.first {
                        window.toggleFullScreen(nil)
                    }
                }
                .keyboardShortcut("f", modifiers: [.command])
            }
        }
    }
}

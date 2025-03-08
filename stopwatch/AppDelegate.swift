//
//  AppDelegate.swift
//  stopwatch
//
//  Created by Joshua Coronado on 3/7/25.
//
import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create the window
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        // Configure the window
        window.title = "Stopwatch"
        window.center()
        window.contentView = NSHostingView(rootView: ContentView())
        window.makeKeyAndOrderFront(nil)
        window.level = .floating // Keep window on top
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenPrimary]
        
        // Set the window to be transparent if needed
        window.isOpaque = false
        window.backgroundColor = NSColor.black.withAlphaComponent(0.8)
        
        self.window = window
    }
}


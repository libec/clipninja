//
//  ClipNinjaApp.swift
//  ClipNinja
//
//  Created by Libor Huspenina on 22.10.2021.
//

import SwiftUI
import AppStart

@main
struct ClipNinjaApp: App {

    let appStart = AppStart()

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            RootView(appStart: appStart)
                .onAppear {
                    NSApp.activate(ignoringOtherApps: true)
                }
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(_ notification: Notification) {

        let contentView = VStack {
            Text("Show Clipboard")
            Text("Preferences")
            Text("Clear all")
            Text("Quit")
        }

        let view = NSHostingView(rootView: contentView)

        // Don't forget to set the frame, otherwise it won't be shown.
        view.frame = NSRect(x: 0, y: 0, width: 200, height: 200)

        let menuItem = NSMenuItem()
        menuItem.view = view

        let menu = NSMenu()
        menu.addItem(menuItem)

        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.statusItem?.menu = menu
        self.statusItem?.button?.title = "ClipNinja"
    }
}

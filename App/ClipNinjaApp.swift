//
//  ClipNinjaApp.swift
//  ClipNinja
//
//  Created by Libor Huspenina on 22.10.2021.
//

import SwiftUI
import AppStart

let appStart = AppStart()

@main
struct ClipNinjaApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(appStart: appStart)
        }
    }
}

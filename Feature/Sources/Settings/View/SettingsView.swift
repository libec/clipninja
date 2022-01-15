import SwiftUI
import Navigation

public struct SettingsView: View {

    @EnvironmentObject private var windowsState: AppWindowsState

    public init() { }

    public var body: some View {
        VStack {
            Button("Show Clipboards") {
                windowsState.mainViewHidden = false
                NSApp.activate(ignoringOtherApps: true)
            }
            Text("Preferences")
            Text("Clear all")
            Button("Quit") {
                exit(0)
            }
        }
    }
}


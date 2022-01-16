import SwiftUI
import Generic
import Infrastructure

public struct SettingsView: View {

    @EnvironmentObject private var windowsState: AppWindowsState

    public init() { }

    public var body: some View {
        VStack {
            Button("Show Clipboards") {
                windowsState.mainViewHidden = false
                NSApp.activate(ignoringOtherApps: true)
            }
            RecordShortcutView()
            Button("Quit") {
                exit(0)
            }
        }
    }
}

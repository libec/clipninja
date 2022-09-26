import SwiftUI

public struct SettingsView: View {

    @EnvironmentObject private var windowsState: AppWindowsState

    init() { }

    public var body: some View {
        VStack {
            Button("Show Clipboards") {
                windowsState.showClipboard = true
                NSApp.activate(ignoringOtherApps: true)
            }
            RecordShortcutView()
            Button("Quit") {
                exit(0)
            }
        }
    }
}

import SwiftUI

public struct SettingsView: View {

    init() { }

    public var body: some View {
        VStack {
            Button("Show Clipboards") {
                NSApp.activate(ignoringOtherApps: true)
            }
            RecordShortcutView()
            Button("Quit") {
                exit(0)
            }
        }
    }
}

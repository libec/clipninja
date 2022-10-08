import SwiftUI

public struct SettingsView: View {

    init() { }

    private var accessibilityUrl: URL? {
        let privacyUrlString = "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
        return URL(string: privacyUrlString)
    }

    public var body: some View {
        VStack {
            Button("Show Clipboards") {
                NSApp.activate(ignoringOtherApps: true)
            }
            Text("Process is trusted: \(AXIsProcessTrusted() ? "true" : "false")")
            Button("Open Privacy Settings") {
                if let url = accessibilityUrl {
                    NSWorkspace.shared.open(url)
                }
            }
            RecordShortcutView()
            Button("Quit") {
                exit(0)
            }
        }
    }
}

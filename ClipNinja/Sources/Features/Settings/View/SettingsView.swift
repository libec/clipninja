import SwiftUI

public struct SettingsView: View {

    private let recordShortcutView: AnyView

    init(recordShortcutView: AnyView) {
        self.recordShortcutView = recordShortcutView
    }

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
            recordShortcutView
            Button("Quit") {
                exit(0)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {

    static var recordShortcutView: AnyView {
        AnyView(
            Color.green
                .frame(width: 200, height: 80)
        )
    }

    public static var previews: some View {
        SettingsView(recordShortcutView: recordShortcutView)
            .frame(width: 400, height: 200)
            .preferredColorScheme(.dark)
    }
}

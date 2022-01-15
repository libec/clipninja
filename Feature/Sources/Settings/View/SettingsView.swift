import SwiftUI

public struct SettingsView: View {

    public init() { }

    public var body: some View {
        VStack {
            Text("Show Clipboard")
            Text("Preferences")
            Text("Clear all")
            Button("Quit") {
                exit(0)
            }
        }
    }
}


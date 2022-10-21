import SwiftUI
import KeyboardShortcuts

struct RecordShortcutView: View {

    init() { }

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("Shortcut to show clipboards:")
            KeyboardShortcuts.Recorder(for: .toggleClipNinja) { shortcut in
            }
        }
    }
}

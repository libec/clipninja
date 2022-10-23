import SwiftUI
import KeyboardShortcuts

struct RecordShortcutView: View {

    init() { }

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("Open ClipNinja Shortcut")
            KeyboardShortcuts.Recorder(for: .toggleClipNinja) { shortcut in
            }
        }
    }
}

import ClipNinjaPackage
import SwiftUI
import KeyboardShortcuts

struct RecordShortcutView: View {

    init() { }

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(Strings.Settings.openAppShortcut)
            KeyboardShortcuts.Recorder(for: .toggleClipNinja) { shortcut in
            }
        }
    }
}

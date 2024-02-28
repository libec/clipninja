import ClipNinjaPackage
import KeyboardShortcuts
import SwiftUI

struct RecordShortcutView: View {
    init() {}

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(Strings.Settings.openAppShortcut)
            KeyboardShortcuts.Recorder(for: .toggleClipNinja) { _ in
            }
        }
    }
}

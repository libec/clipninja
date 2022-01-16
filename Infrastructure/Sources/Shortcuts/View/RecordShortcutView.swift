import KeyboardShortcuts
import SwiftUI

public struct RecordShortcutView: View {

    public init() { }

    public var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("Shortcut to show clipboards:")
            KeyboardShortcuts.Recorder(for: .toggleClipNinja) { shortcut in
                print(shortcut?.description)
            }
        }
    }
}

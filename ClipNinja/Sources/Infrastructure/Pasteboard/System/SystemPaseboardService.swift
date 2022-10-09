import AppKit

final class SystemPaseboardService: PasteboardService {

    let systemPasteboard: NSPasteboard

    init(systemPasteboard: NSPasteboard) {
        self.systemPasteboard = systemPasteboard
    }

    func insert(text: String) {
        systemPasteboard.clearContents()
        systemPasteboard.setString(text, forType: NSPasteboard.PasteboardType.string)
    }
}

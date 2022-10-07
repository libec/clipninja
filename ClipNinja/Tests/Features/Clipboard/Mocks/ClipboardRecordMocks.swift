@testable import ClipNinja

extension ClipboardRecord {
    static func numberStubs(amount: Int) -> [ClipboardRecord] {
        (0...amount).map {
            ClipboardRecord(text: "\($0)", pinned: false)
        }
    }
}

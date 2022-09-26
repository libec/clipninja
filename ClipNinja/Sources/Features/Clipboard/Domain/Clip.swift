import Foundation

public struct Clip: Codable {
    let text: String
    let pinned: Bool
    let selected: Bool
}

struct ClipboardRecord: Codable {
    let text: String
    let pinned: Bool
}

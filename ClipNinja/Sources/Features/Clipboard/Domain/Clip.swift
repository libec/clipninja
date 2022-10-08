import Foundation

// TODO: - Revisit name
struct Clip: Codable, Equatable {
    let text: String
    let pinned: Bool
    let selected: Bool
}

// TODO: - Revisit name
struct ClipboardRecord: Codable {
    let text: String
    let pinned: Bool
}

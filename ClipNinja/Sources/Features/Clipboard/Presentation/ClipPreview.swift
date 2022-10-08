import Foundation

// TODO: - Revisit name
struct ClipPreview: Codable, Equatable, Identifiable {

    var id: String { UUID().uuidString }

    let previewText: String
    let selected: Bool
    let pinned: Bool
    let shortcutNumber: String
}

struct ClipPreview: Codable, Equatable, Identifiable {
    typealias ObjectIdentifier = String
    // TODO: - Replace with real identifier
    var id: ObjectIdentifier {
        return "\(previewText) + \(shortcutNumber)"
    }

    let previewText: String
    let selected: Bool
    let pinned: Bool
    let shortcutNumber: String
}

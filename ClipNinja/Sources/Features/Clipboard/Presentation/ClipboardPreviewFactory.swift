protocol ClipboardPreviewFactory {
    func makePreview(from clip: Clip, index: Int) -> ClipPreview
}

class ClipboardPreviewFactoryImpl: ClipboardPreviewFactory {
    func makePreview(from clip: Clip, index: Int) -> ClipPreview {
        let lines = clip.text.split(
            maxSplits: .max,
            omittingEmptySubsequences: true,
            whereSeparator: { $0 == "\n" || $0 == "\r" }
        )
        let firstNonEmptyLine = lines.first.map { $0.trimmingCharacters(in: .whitespaces) } ?? ""

        return ClipPreview(
            previewText: firstNonEmptyLine,
            selected: clip.selected,
            pinned: clip.pinned,
            shortcutNumber: "\(index + 1)"
        )
    }
}

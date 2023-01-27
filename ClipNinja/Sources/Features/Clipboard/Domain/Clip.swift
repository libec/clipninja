import Foundation

struct Clip: Equatable, Codable {
    let text: String
    var pinned: Bool

    static func newClip(with text: String) -> Clip {
        Clip(text: text, pinned: false)
    }
}

@testable import ClipNinja

extension Clip {
    static func numberStubs(range: Range<Int>, selected: Int) -> [Clip] {
        range.enumerated().map { (index, number) in
            Clip(text: "\(number)", pinned: false, selected: index == selected)
        }
    }
}

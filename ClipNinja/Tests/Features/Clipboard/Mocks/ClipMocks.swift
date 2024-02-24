@testable import ClipNinjaPackage

extension Clip {
    static func numberStubs(range: Range<Int>) -> [Clip] {
        range.enumerated().map { _, number in
            Clip(text: "\(number)", pinned: false)
        }
    }

    static func numberStubs(amount: Int) -> [Clip] {
        (0 ... amount).map {
            Clip(text: "\($0)", pinned: false)
        }
    }
}

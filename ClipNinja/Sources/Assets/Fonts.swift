import SwiftUI

extension Font {

    static func avenir(size: CGFloat) -> Font {
        .custom("Avenir Next", size: size)
    }

    static func courier(size: CGFloat) -> Font {
        .custom("Courier New", size: size)
    }

    static func mono(size: CGFloat) -> Font {
        custom("SF Mono", fixedSize: size)
    }
}

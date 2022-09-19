import SwiftUI
import Carbon

struct KeyEventHandling: NSViewRepresentable {

    class KeyView: NSView {
        override var acceptsFirstResponder: Bool { true }

        override func keyDown(with event: NSEvent) {
            print("\(event.keyCode)")
            print(CGKeyCode(kVK_ANSI_KeypadEnter))
        }
    }

    func makeNSView(context: Context) -> NSView {
        KeyView()
    }

    func updateNSView(_ nsView: NSView, context: Context) { }
}

public struct ClipboardView: View {

    private let navigation: Navigation

    public init(navigation: Navigation) {
        self.navigation = navigation
    }

    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ForEach(1..<10) { row in
                    ClipboardRow(
                        text: randomAlphaNumericString(length: 15),
                        shortcut: "\(row)",
                        pinned: row < 6,
                        selected: row == 3
                    )
                }
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height,
                alignment: .center
            )
        }
        .background(KeyEventHandling())
    }

    func randomAlphaNumericString(length: Int) -> String {
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.count)
        var randomString = ""

        for _ in 0 ..< length {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
            let newCharacter = allowedChars[randomIndex]
            randomString += String(newCharacter)
        }

        return randomString
    }

    func color(for row: Int, column: Int) -> some View {
        let white = Color(red: 1, green: 1, blue: 1)
        let black = Color(red: 0, green: 0, blue: 0)
        let oddRow = row % 2 == 0
        let oddColumn = column % 2 == 0
        let shouldUseBlack = (oddRow && oddColumn) || (!oddRow && !oddColumn)
        return shouldUseBlack ? black : white
    }
}

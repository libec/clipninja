import SwiftUI

public struct ClipboardView: View {

    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ForEach(0..<10) { column in
                    HStack(spacing: 0) {
                        ForEach(0..<10) { row in
                            color(for: row, column: column)
                                .frame(
                                    width: geometry.size.width / 10,
                                    height: geometry.size.width / 10,
                                    alignment: .center
                                )
                        }
                    }
                }
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height,
                alignment: .center
            )
        }
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

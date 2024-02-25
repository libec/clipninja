import SwiftUI

struct HighlightedImage: View {
    let systemName: String

    init(systemName: String) {
        self.systemName = systemName
    }

    var body: some View {
        Image(systemName: systemName)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .foregroundColor(Colors.selectedTextColor)
            .background(Colors.prominent)
    }
}

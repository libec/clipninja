import SwiftUI

struct TitleText: View {
    private let title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        Text(title)
            .font(.avenir(size: 22))
            .fontWeight(.bold)
            .foregroundColor(Colors.defaultTextColor)
    }
}

struct DescriptionText: View {
    private let title: String

    init(_ text: String) {
        title = text
    }

    var body: some View {
        Text(title)
            .foregroundColor(Colors.defaultTextColor)
            .font(.avenir(size: 18))
            .fontWeight(.bold)
    }
}

struct HighlightedDescriptionText: View {
    private let title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        Text(title)
            .padding(6)
            .background(Colors.prominent)
            .cornerRadius(4, antialiased: true)
            .foregroundColor(Colors.selectedTextColor)
            .font(.courier(size: 20))
            .fontWeight(.bold)
    }
}

struct HighlightedAlternatingText: View {
    private let title: String
    private let alternativeTitle: String

    @State private var useAlternativeTitle: Bool = false

    let timer = Timer.publish(every: 2, tolerance: 0.3, on: .main, in: .common).autoconnect()

    init(_ title: String, alternativeTitle: String) {
        self.title = title
        self.alternativeTitle = alternativeTitle
    }

    var body: some View {
        Text(useAlternativeTitle ? alternativeTitle : title)
            .padding(6)
            .background(Colors.prominent)
            .cornerRadius(4, antialiased: true)
            .foregroundColor(Colors.selectedTextColor)
            .font(.courier(size: 20))
            .fontWeight(.bold)
            .onReceive(timer) { _ in
                withAnimation {
                    useAlternativeTitle.toggle()
                }
            }
    }
}

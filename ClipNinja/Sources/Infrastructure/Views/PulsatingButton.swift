import SwiftUI

struct PulsatingButton: View {
    private let action: () -> Void
    private let title: String

    @State private var pulsate: Bool = false

    @State private var scale: CGFloat = 0.9

    init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    var body: some View {
        Button(title, action: action)
            .font(.avenir(size: 20))
            .fontWeight(.bold)
            .padding(10)
            .buttonStyle(.borderless)
            .background(Colors.prominent)
            .foregroundColor(Colors.selectedTextColor)
            .cornerRadius(scale > 0.9 ? 12 : 8, antialiased: true)
            .scaleEffect(scale)
            .onAppear {
                let animation = Animation.easeInOut(duration: 1)
                    .delay(0.3)
                    .repeatForever(autoreverses: true)

                withAnimation(animation) {
                    scale = 1
                }
            }
    }
}

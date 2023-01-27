import SwiftUI

extension Bool {
    func binding(onChange: @escaping () -> Void) -> Binding<Bool> {
        return Binding<Bool> {
            self
        } set: { _ in
            onChange()
        }

    }
}

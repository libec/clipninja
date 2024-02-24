import SwiftUI

extension Bool {
    func binding(onChange: @escaping () -> Void) -> Binding<Bool> {
        Binding<Bool> {
            self
        } set: { _ in
            onChange()
        }
    }
}

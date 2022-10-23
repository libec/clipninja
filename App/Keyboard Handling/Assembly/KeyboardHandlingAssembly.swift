import ClipNinjaPackage
import Swinject
import SwinjectAutoregistration
import SwiftUI

struct KeyboardHandlingAssembly: Assembly {

    private let keyboardNotifier: KeyboardNotifier

    init(keyboardNotifier: KeyboardNotifier) {
        self.keyboardNotifier = keyboardNotifier
    }

    func assemble(container: Container) {
        container.register(AnyView.self, name: AssemblyKeys.recordShortcutView.rawValue) { _ in
            AnyView(RecordShortcutView())
        }
        container.autoregister(ShortcutObserver.self, initializer: SystemShortcutObserver.init)
            .inObjectScope(.container)
        container.register(KeyboardNotifier.self) { _ in keyboardNotifier }
    }

    func loaded(resolver: Resolver) {
        resolver.resolve(ShortcutObserver.self)?.observe()
    }
}

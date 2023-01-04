import ClipNinjaPackage
import Swinject
import SwinjectAutoregistration
import SwiftUI

struct KeyboardHandlingAssembly: Assembly {

    private let keyboardObserver: KeyboardObserver

    init(keyboardObserver: KeyboardObserver) {
        self.keyboardObserver = keyboardObserver
    }

    func assemble(container: Container) {
        container.register(AnyView.self, name: AssemblyKeys.recordShortcutView.rawValue) { _ in
            AnyView(RecordShortcutView())
        }
        container.autoregister(ShortcutObserver.self, initializer: SystemShortcutObserver.init)
            .inObjectScope(.container)
        container.register(KeyboardObserver.self) { _ in keyboardObserver }
    }

    func loaded(resolver: Resolver) {
        resolver.resolve(ShortcutObserver.self)?.observe()
    }
}

import ClipNinjaPackage
import Swinject
import SwinjectAutoregistration
import SwiftUI

struct KeyboardHandlingAssembly: Assembly {

    func assemble(container: Container) {
        container.autoregister(SystemKeyboardObserver.self, initializer: SystemKeyboardObserver.init)
            .implements(KeyboardObserver.self)
            .inObjectScope(.container)
        container.register(AnyView.self, name: AssemblyKeys.recordShortcutView.rawValue) { _ in
            AnyView(RecordShortcutView())
        }
        container.autoregister(ShortcutObserver.self, initializer: SystemShortcutObserver.init)
            .inObjectScope(.container)
    }

    func loaded(resolver: Resolver) {
        resolver.resolve(ShortcutObserver.self)?.observe()
    }
}

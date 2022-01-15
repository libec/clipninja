import Swinject
import SwinjectAutoregistration
import Navigation

public final class ClipboardAssembly: Assembly {

    public init() { }
    
    public func assemble(container: Container) {
        container.register(ClipboardView.self) { resovler, argument in
            ClipboardView(navigation: resovler.resolve(Navigation.self)!, hiddenBinding: argument)
        }
    }
}

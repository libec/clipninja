import Swinject
import SwinjectAutoregistration

public class LoggerAssembly: Assembly {

    public init() { }
    
    public func assemble(container: Container) {
        container.autoregister(Logger.self, initializer: PrintLogger.init)
    }
}

public protocol InstanceProvider {
    func resolve<Instance>(_ type: Instance.Type) -> Instance
    func resolve<Instance, Argument>(_ type: Instance.Type, argument: Argument) -> Instance
}

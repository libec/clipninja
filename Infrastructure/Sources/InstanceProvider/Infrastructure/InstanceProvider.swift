public protocol InstanceProvider {
    func resolve<Instance>(_ type: Instance.Type) -> Instance
}

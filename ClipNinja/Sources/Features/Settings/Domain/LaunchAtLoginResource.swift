public protocol LaunchAtLoginResource {
    var enabled: Bool { get }
    func enable()
    func disable()
}

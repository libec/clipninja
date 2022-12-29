public protocol LaunchAtLoginService {
    var enabled: Bool { get }
    func enable()
    func disable()
}

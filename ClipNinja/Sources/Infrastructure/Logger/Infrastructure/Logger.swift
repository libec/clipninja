import os

protocol Logger {
    func log(message: String)
}

class SystemLogger: Logger {

    private let systemLogger = os.Logger(subsystem: "clipninja", category: "main")
    
    func log(message: String) {
        systemLogger.log("\(message)")
    }
}

struct LoggerHolder {
    static let logger: Logger = SystemLogger()
}

public func log(message: String) {
    LoggerHolder.logger.log(message: message)
}

import os
import Foundation

private protocol Logger {
    func log(message: String, category: LogCategory)
}

public enum LogCategory {
    case main
    case storage
}

private final class SystemLogger: Logger {

    private let subsystem = Bundle.main.bundleIdentifier!

    private let systemLogger: os.Logger
    private let storageLogger: os.Logger

    fileprivate init() {
        self.systemLogger = os.Logger(subsystem: subsystem, category: "system")
        self.storageLogger = os.Logger(subsystem: subsystem, category: "storage")
    }
    
    fileprivate func log(message: String, category: LogCategory) {
        switch category {
        case .main:
            systemLogger.log("\(message)")
        case .storage:
            storageLogger.log("\(message)")
        }
    }
}

private struct LoggerWrapper {
    fileprivate static let logger: Logger = SystemLogger()
}

public func log(message: String, category: LogCategory = .main) {
    LoggerWrapper.logger.log(message: message, category: category)
}

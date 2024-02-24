import Foundation
import os

private protocol Logger {
    func log(message: String, category: LogCategory)
}

public enum LogCategory: CaseIterable {
    case main
    case storage
    case tutorial
    case viewPort
    case windows
    case migration

    fileprivate var logDescription: String {
        switch self {
        case .main: return "system"
        case .storage: return "storage"
        case .tutorial: return "tutorial"
        case .viewPort: return "view port"
        case .windows: return "windows"
        case .migration: return "migration"
        }
    }

    fileprivate func makeLogger(subsystem: String) -> os.Logger {
        os.Logger(subsystem: subsystem, category: logDescription)
    }
}

private final class SystemLogger: Logger {
    private let subsystem = Bundle.main.bundleIdentifier!
    private let silentCategories: [LogCategory]

    private lazy var loggers: [LogCategory: os.Logger] = {
        LogCategory.allCases.reduce(into: [LogCategory: os.Logger]()) { allLogs, category in
            allLogs[category] = category.makeLogger(subsystem: subsystem)
        }
    }()

    fileprivate init(silentCategories: [LogCategory]) {
        self.silentCategories = silentCategories
    }

    fileprivate func log(message: String, category: LogCategory) {
        if silentCategories.contains(category) { return }
        loggers[category]?.log("\(message)")
    }
}

private enum LoggerWrapper {
    fileprivate static let silentCategories: [LogCategory] = [
    ]
    fileprivate static let logger: Logger = SystemLogger(silentCategories: silentCategories)
}

public func log(message: String, category: LogCategory = .main) {
    LoggerWrapper.logger.log(message: message, category: category)
}

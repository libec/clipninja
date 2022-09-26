protocol Logger {
    func log(message: String)
}

class PrintLogger: Logger {
    func log(message: String) {
        print(message)
    }
}

struct LoggerHolder {
    static let logger: Logger = PrintLogger()
}

func log(message: String) {
    LoggerHolder.logger.log(message: message)
}

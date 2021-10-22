public protocol Logger {
    func log(message: String)
}

class PrintLogger: Logger {
    func log(message: String) {
        print(message)
    }
}

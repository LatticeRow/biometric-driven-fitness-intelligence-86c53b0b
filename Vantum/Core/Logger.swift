import OSLog

struct AppLogger {
    private let logger: Logger

    init(subsystem: String) {
        logger = Logger(subsystem: subsystem, category: "app")
    }

    func log(_ message: String) {
        logger.log("\(message, privacy: .public)")
    }
}

import ProvisioningProfile

class TestLogger: Logger {
    
    struct LogEntry {
        let level: LogLevel
        let message: String
    }
    
    var logs = [LogEntry]()
    
    func log(_ level: LogLevel, message: String) {
        let entry = LogEntry(level: level, message: message)
        logs.append(entry)
    }
    
}

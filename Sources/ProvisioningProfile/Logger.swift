//
//  Logger.swift
//  
//
//  Created by Chris Mash on 30/11/2020.
//

import Foundation

/// The possible levels of log messages provided through the `Logger` protocol.
public enum LogLevel {
    /// Informative messages
    case info
    /// Debug messages
    case debug
    /// Warning messages
    case warning
    /// Error messages
    case error
}

/// Implement this protocol and assign to `ProvisioningProfile.logger` to receive logs from the loading
/// and parsing of the profile.
public protocol Logger {
    /// Called when a log message is available
    ///  - parameter level: The level of the log message
    ///  - parameter message: The log message
    func log(_ level: LogLevel, message: String)
}

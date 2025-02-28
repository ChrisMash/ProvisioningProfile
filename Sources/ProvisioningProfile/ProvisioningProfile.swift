//
//  ProvisioningProfile.swift
//
//
//  Created by Chris Mash on 05/11/2020.
//

import Foundation

/// Representation of a provisioning profile
public struct ProvisioningProfile {
    /// Custom `DateFormatter` for generating `formattedExpiryDate`, defaults to `nil`.
    /// If required, ensure you set this property before accessing `profile()`.
    public static var dateFormatter: DateFormatter?
    /// Custom `Logger` implementation for receiving logged messages, defaults to `nil`.
    /// If required, ensure you set this property before accessing `profile()`.
    public static var logger: Logger?
    
    /// The name of the provisioning profile, if successfully parsed.
    public let name: String?
    /// The expiry date of the provisioning profile as a `Date`, if successfully parsed.
    public let expiryDate: Date?
    /// The expiry date of the provisioning profile as a formatted `String`, if successfully parsed.
    /// The default formatting is `short` for both date and time. Provide your own `DateFormatter`
    /// to `dateForamtter` to override this.
    public let formattedExpiryDate: String?
    
    internal static var cachedProfile: ProvisioningProfile?
    internal static var bundleToLoadFrom: Bundle?
    
    /// The provisioning profile for the current app, if available.
    /// On simulators this function will always return `nil`.
    /// In a macOS app this function will always return `nil` unless the app requires certain entitlements,
    /// such as push notifications and iCloud.
    public static func profile() -> ProvisioningProfile? {
        if cachedProfile == nil {
            cachedProfile = loadProfile()
        }
        
        return cachedProfile
    }
    
    internal init(name: String?, expiryDate: Date?) {
        self.name = name
        self.expiryDate = expiryDate
        
        if let expiry = expiryDate {
            // Format the date into a presentable form
            formattedExpiryDate = ProvisioningProfile.format(date: expiry)
        }
        else {
            formattedExpiryDate = nil
        }
    }

    private static func loadProfile() -> ProvisioningProfile? {
        // Load embedded.mobileprovision from the bundle
        let bundle = bundleToLoadFrom ?? Bundle.main
        let profileExt: String
        #if os(macOS)
            profileExt = "provisionprofile"
        #else
            profileExt = "mobileprovision"
        #endif
        
        // Try reading the file as ASCII (used to work ok, pre Xcode 16?)
        do {
            let asciiContent = try FileLoader.loadFile(bundle: bundle,
                                                       filename: "embedded",
                                                       extension: profileExt,
                                                       encoding: .ascii)
            return ProvisioningProfileParser.parse(string: asciiContent, logger: logger)
        } catch {
            // That's ok
        }
        
        // Try reading the file as Latin-1 (works ok in Xcode 16)
        do {
            let latin1Content = try FileLoader.loadFile(bundle: bundle,
                                                        filename: "embedded",
                                                        extension: profileExt,
                                                        encoding: .isoLatin1)
            return ProvisioningProfileParser.parse(string: latin1Content, logger: logger)
        } catch {
            logger?.log(.error, message: "Error loading profile: \(error)")
        }
        
        return nil
    }
    
    private static func format(date: Date) -> String {
        if let formatter = ProvisioningProfile.dateFormatter {
            // externally supplied formatter
            return formatter.string(from: date)
        }
        else {
            // default formatter
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            formatter.timeZone = .current
            formatter.locale = .current
            return formatter.string(from: date)
        }
    }
    
}

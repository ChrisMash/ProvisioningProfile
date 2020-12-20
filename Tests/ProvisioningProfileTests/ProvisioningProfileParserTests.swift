import XCTest
@testable import ProvisioningProfile

final class ProvisioningProfileParserTests: XCTestCase {
    
    func testInitEmptyString() throws {
        let logger = TestLogger()
        let provProfile = ProvisioningProfileParser.parse(string: "",
                                                          logger: logger)
        XCTAssertNil(provProfile.expiryDate)
        XCTAssertNil(provProfile.formattedExpiryDate)
        XCTAssertNil(provProfile.name)
        
        XCTAssertEqual(logger.logs.count, 2)
        let firstLog = try XCTUnwrap(logger.logs.first)
        XCTAssertEqual(firstLog.level, .warning)
        XCTAssertEqual(firstLog.message, "Error reading profile name: notFound")
        let secondLog = try XCTUnwrap(logger.logs.dropFirst(1).first)
        XCTAssertEqual(secondLog.level, .warning)
        XCTAssertEqual(secondLog.message, "Error reading profile expiry date: notFound")
    }

    func testInitNotProfile() throws {
        let logger = TestLogger()
        let provProfile = ProvisioningProfileParser.parse(string: "abc",
                                                          logger: logger)
        XCTAssertNil(provProfile.expiryDate)
        XCTAssertNil(provProfile.formattedExpiryDate)
        XCTAssertNil(provProfile.name)
        
        XCTAssertEqual(logger.logs.count, 2)
        let firstLog = try XCTUnwrap(logger.logs.first)
        XCTAssertEqual(firstLog.level, .warning)
        XCTAssertEqual(firstLog.message, "Error reading profile name: notFound")
        let secondLog = try XCTUnwrap(logger.logs.dropFirst(1).first)
        XCTAssertEqual(secondLog.level, .warning)
        XCTAssertEqual(secondLog.message, "Error reading profile expiry date: notFound")
    }

    func testInitValidProfile() throws {
        let logger = TestLogger()
        let provProfile = ProvisioningProfileParser.parse(string: try TestUtils.profile("embedded"),
                                                          logger: logger)
        XCTAssertEqual(provProfile.expiryDate, TestUtils.expectedDate())
        XCTAssertEqual(provProfile.formattedExpiryDate, TestUtils.expectedDefaultFormattedDate())
        XCTAssertEqual(provProfile.name, "ProfileName")
        
        XCTAssertEqual(logger.logs.count, 0)
    }

    func testInitProfileWithoutDate() throws {
        let logger = TestLogger()
        let provProfile = ProvisioningProfileParser.parse(string: try TestUtils.profile("missingdate"),
                                                          logger: logger)
        XCTAssertNil(provProfile.expiryDate)
        XCTAssertNil(provProfile.formattedExpiryDate)
        XCTAssertEqual(provProfile.name, "ProfileName")
        
        XCTAssertEqual(logger.logs.count, 1)
        let firstLog = try XCTUnwrap(logger.logs.first)
        XCTAssertEqual(firstLog.level, .warning)
        XCTAssertEqual(firstLog.message, "Error reading profile expiry date: notFound")
    }
    
    func testInitProfileWithInvalidDate() throws {
        let logger = TestLogger()
        let provProfile = ProvisioningProfileParser.parse(string: try TestUtils.profile("invaliddate"),
                                                          logger: logger)
        XCTAssertNil(provProfile.expiryDate)
        XCTAssertNil(provProfile.formattedExpiryDate)
        XCTAssertEqual(provProfile.name, "ProfileName")
        
        XCTAssertEqual(logger.logs.count, 1)
        let firstLog = try XCTUnwrap(logger.logs.first)
        XCTAssertEqual(firstLog.level, .warning)
        XCTAssertEqual(firstLog.message, "Error reading profile expiry date: parsingError")
    }
    
    static var allTests = [
        ("testInitEmptyString", testInitEmptyString),
        ("testInitNotProfile", testInitNotProfile),
        ("testInitValidProfile", testInitValidProfile),
        ("testInitProfileWithoutDate", testInitProfileWithoutDate),
        ("testInitProfileWithInvalidDate", testInitProfileWithInvalidDate)
    ]
}

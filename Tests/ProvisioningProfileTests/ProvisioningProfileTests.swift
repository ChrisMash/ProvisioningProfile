import XCTest
@testable import ProvisioningProfile

final class ProvisioningProfileTests: XCTestCase {
    
    private var logger: TestLogger?
    
    override func setUpWithError() throws {
        logger = TestLogger()
        ProvisioningProfile.logger = logger
    }
    
    override func tearDownWithError() throws {
        ProvisioningProfile.cachedProfile = nil
        ProvisioningProfile.bundleToLoadFrom = nil
        ProvisioningProfile.dateFormatter = nil
    }
    
    func testInitOptionals() throws {
        let provProfile = ProvisioningProfile(name: nil,
                                              expiryDate: nil)
        XCTAssertNil(provProfile.name)
        XCTAssertNil(provProfile.expiryDate)
        XCTAssertNil(provProfile.formattedExpiryDate)
    }

    func testInitValues() throws {
        let name = "name"
        let expiryDate = TestUtils.expectedDate()
        let provProfile = ProvisioningProfile(name: name,
                                              expiryDate: expiryDate)
        XCTAssertEqual(provProfile.name, name)
        XCTAssertEqual(provProfile.expiryDate, expiryDate)
        XCTAssertEqual(provProfile.formattedExpiryDate, TestUtils.expectedDefaultFormattedDate())
    }
    
    func testCustomFormatter() throws {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .long
        formatter.timeZone = .current
        formatter.locale = Locale(identifier: "en_US")
        ProvisioningProfile.dateFormatter = formatter
        
        let provProfile = ProvisioningProfile(name: "name",
                                              expiryDate: TestUtils.expectedDate())
        XCTAssertEqual(provProfile.formattedExpiryDate, "October 17, 2021 at 3:04:18 PM GMT+1")
    }
    
    func testStaticInitialiserForMainBundle() throws {
        let provProfile = ProvisioningProfile.profile()
        // tests don't have the main bundle
        XCTAssertNil(provProfile)
        
        XCTAssertEqual(logger?.logs.count, 1)
        let firstLog = try XCTUnwrap(logger?.logs.first)
        XCTAssertEqual(firstLog.level, .error)
        XCTAssertEqual(firstLog.message, "Error loading profile: fileNotFound")
    }
    
    func testStaticInitialiserForModuleBundle() throws {
        ProvisioningProfile.bundleToLoadFrom = Bundle.module
        let provProfile = try XCTUnwrap(ProvisioningProfile.profile())
        // tests have profiles in the module bundle
        XCTAssertEqual(provProfile.expiryDate, TestUtils.expectedDate())
        XCTAssertEqual(provProfile.formattedExpiryDate, TestUtils.expectedDefaultFormattedDate())
        
        XCTAssertEqual(logger?.logs.count, 0)
    }
    
    func testCachedProfile() throws {
        // Loading from the module bundle, which has embedded.mobileprovision
        ProvisioningProfile.bundleToLoadFrom = Bundle.module
        let provProfile = try XCTUnwrap(ProvisioningProfile.profile())
        // we get a valid profile loaded
        XCTAssertNotNil(provProfile)
        XCTAssertNotNil(provProfile.expiryDate)
        // and no errors logged
        XCTAssertEqual(logger?.logs.count, 0)
        
        // Switching back to load from the main bundle (which has no profile)
        ProvisioningProfile.bundleToLoadFrom = nil
        let provProfile2 = try XCTUnwrap(ProvisioningProfile.profile())
        // Still get a vaid profile (cached)
        XCTAssertNotNil(provProfile2)
        XCTAssertNotNil(provProfile2.expiryDate)
        // And no logs (because the cached profile was returned with no loading
        XCTAssertEqual(logger?.logs.count, 0)
    }

    static var allTests = [
        ("testInitOptionals", testInitOptionals),
        ("testInitValues", testInitValues),
        ("testCustomFormatter", testCustomFormatter),
        ("testStaticInitialiserForMainBundle", testStaticInitialiserForMainBundle),
        ("testStaticInitialiserForModuleBundle", testStaticInitialiserForModuleBundle),
        ("testCachedProfile", testCachedProfile)
    ]
}

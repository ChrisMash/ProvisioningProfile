import XCTest
@testable import ProvisioningProfile

final class FileLoaderTests: XCTestCase {
    
    func testValidPath() throws {
        let contents = try FileLoader.loadFile(bundle: .module,
                                               filename: "test",
                                               extension: "txt",
                                               encoding: .ascii)
        XCTAssertEqual(contents, "filecontents\n")
    }
    
    func testInvalidPath() throws {
        XCTAssertThrowsError(try FileLoader.loadFile(bundle: .module,
                                                     filename: "wrong",
                                                     extension: "txt",
                                                     encoding: .ascii),
                             "Expected to throw .fileNotFound") { error in
            XCTAssertEqual(error as? FileLoader.Error, .fileNotFound)
        }
    }
    
    func testWrongEncoding() throws {
        XCTAssertThrowsError(try FileLoader.loadFile(bundle: .module,
                                                     filename: "embedded",
                                                     extension: "mobileprovision",
                                                     encoding: .utf8),
                             "Expected to throw .incorrectEncoding") { error in
            XCTAssertEqual(error as? FileLoader.Error, .incorrectEncoding)
        }
    }
    
    static var allTests = [
        ("testValidPath", testValidPath),
        ("testInvalidPath", testInvalidPath),
        ("testWrongEncoding", testWrongEncoding)
    ]
}

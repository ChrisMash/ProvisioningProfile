import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(FileLoaderTests.allTests),
        testCase(ProvisioningProfileTests.allTests)
    ]
}
#endif

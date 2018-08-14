import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Swift_Dependency_ManagerTests.allTests),
    ]
}
#endif
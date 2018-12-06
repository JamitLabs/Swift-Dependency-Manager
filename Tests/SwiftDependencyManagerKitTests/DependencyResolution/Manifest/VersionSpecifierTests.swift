@testable import SwiftDependencyManagerKit
import XCTest

class VersionSpecifierTests: XCTestCase {
    func testCommonVersionSpecifier() {
        XCTAssertEqual(VersionSpecifier.any.commonVersionSpecifier(with: .any), .any)

        XCTAssertEqual(VersionSpecifier.any, .any)
        XCTAssertEqual(VersionSpecifier.branch("master").commonVersionSpecifier(with: .branch("master")), .branch("master"))
        XCTAssertEqual(VersionSpecifier.commit("0000000000000000000000000000000000000000").commonVersionSpecifier(with: .any), .commit("0000000000000000000000000000000000000000"))
        XCTAssertEqual(VersionSpecifier.branch("master").commonVersionSpecifier(with: .any), .branch("master"))
        XCTAssertEqual(VersionSpecifier.exactVersion("1.5.0").commonVersionSpecifier(with: .any), .exactVersion("1.5.0"))
        XCTAssertEqual(VersionSpecifier.exactVersion("1.5.0").commonVersionSpecifier(with: .exactVersion("1.5.0")), .exactVersion("1.5.0"))
        XCTAssertEqual(VersionSpecifier.minimumVersion("2.0.4").commonVersionSpecifier(with: .any), .minimumVersion("2.0.4"))
        XCTAssertEqual(VersionSpecifier.upToNextMajor("3.5.0").commonVersionSpecifier(with: .any), .upToNextMajor("3.5.0"))


        XCTAssertNil(VersionSpecifier.commit("0000000000000000000000000000000000000000").commonVersionSpecifier(with: .branch("master")))
        XCTAssertNil(VersionSpecifier.branch("develop").commonVersionSpecifier(with: .branch("master")))
        XCTAssertNil(VersionSpecifier.commit("0000000000000000000000000000000000000000").commonVersionSpecifier(with: .commit("1111111111111111111111111111111111111111")))
        XCTAssertNil(VersionSpecifier.exactVersion("1.5.0").commonVersionSpecifier(with: .exactVersion("1.5.1")))
        XCTAssertNil(VersionSpecifier.exactVersion("1.5.0").commonVersionSpecifier(with: .upToNextMajor("1.6.2")))
        XCTAssertNil(VersionSpecifier.exactVersion("1.5.0").commonVersionSpecifier(with: .minimumVersion("1.6.7")))
        XCTAssertNil(VersionSpecifier.upToNextMajor("3.5.0").commonVersionSpecifier(with: .upToNextMajor("4.9.5")))
        XCTAssertNil(VersionSpecifier.minimumVersion("3.0.4").commonVersionSpecifier(with: .upToNextMajor("2.5.0")))
        XCTAssertNil(VersionSpecifier.minimumVersion("2.8.4").commonVersionSpecifier(with: .upToNextMajor("1.5.0")))
    }
}

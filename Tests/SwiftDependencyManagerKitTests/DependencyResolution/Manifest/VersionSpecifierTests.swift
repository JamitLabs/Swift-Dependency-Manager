@testable import SwiftDependencyManagerKit
import XCTest

class VersionSpecifierTests: XCTestCase {
    func testCommonVersionSpecifier() {
        XCTAssertEqual([.any, .any, .any].shuffled().commonVersionSpecifier, .any)
        XCTAssertEqual([.any, .branch("master"), .branch("master")].shuffled().commonVersionSpecifier, .branch("master"))
        XCTAssertEqual([.any, .commit("0000000000000000000000000000000000000000"), .any].shuffled().commonVersionSpecifier, .commit("0000000000000000000000000000000000000000"))
        XCTAssertEqual([.any, .branch("master"), .any].shuffled().commonVersionSpecifier, .branch("master"))
        XCTAssertEqual([.any, .exactVersion("1.5.0"), .any].shuffled().commonVersionSpecifier, .exactVersion("1.5.0"))
        XCTAssertEqual([.any, .exactVersion("1.5.0"), .exactVersion("1.5.0")].shuffled().commonVersionSpecifier, .exactVersion("1.5.0"))
        XCTAssertEqual([.any, .minimumVersion("2.0.4"), .any].shuffled().commonVersionSpecifier, .minimumVersion("2.0.4"))
        XCTAssertEqual([.any, .upToNextMajor("3.5.0"), .any].shuffled().commonVersionSpecifier, .upToNextMajor("3.5.0"))
        XCTAssertEqual([.any, .exactVersion("1.5.0"), .upToNextMajor("1.4.2")].shuffled().commonVersionSpecifier, .exactVersion("1.5.0"))
        XCTAssertEqual([.any, .exactVersion("1.5.0"), .minimumVersion("1.3.7")].shuffled().commonVersionSpecifier, .exactVersion("1.5.0"))
        XCTAssertEqual([.any, .minimumVersion("2.0.4"), .minimumVersion("1.5.0")].shuffled().commonVersionSpecifier, .minimumVersion("2.0.4"))
        XCTAssertEqual([.any, .upToNextMajor("3.5.0"), .upToNextMajor("3.9.5")].shuffled().commonVersionSpecifier, .upToNextMajor("3.9.5"))
        XCTAssertEqual([.any, .minimumVersion("2.0.4"), .upToNextMajor("2.5.0")].shuffled().commonVersionSpecifier, .upToNextMajor("2.5.0"))
        XCTAssertEqual([.any, .minimumVersion("2.8.4"), .upToNextMajor("2.5.0")].shuffled().commonVersionSpecifier, .upToNextMajor("2.8.4"))
        XCTAssertEqual([.exactVersion("2.1.0"), .minimumVersion("2.0.4"), .minimumVersion("1.5.0")].shuffled().commonVersionSpecifier, .exactVersion("2.1.0"))
        XCTAssertEqual([.exactVersion("3.10.0"), .upToNextMajor("3.5.0"), .upToNextMajor("3.9.5")].shuffled().commonVersionSpecifier, .exactVersion("3.10.0"))
        XCTAssertEqual([.exactVersion("2.7.0"), .minimumVersion("2.0.4"), .upToNextMajor("2.5.0")].shuffled().commonVersionSpecifier, .exactVersion("2.7.0"))
        XCTAssertEqual([.exactVersion("2.9.0"), .minimumVersion("2.8.4"), .upToNextMajor("2.5.0")].shuffled().commonVersionSpecifier, .exactVersion("2.9.0"))

        XCTAssertNil([].shuffled().commonVersionSpecifier)
        XCTAssertNil([.any, .commit("0000000000000000000000000000000000000000"), .branch("master")].shuffled().commonVersionSpecifier)
        XCTAssertNil([.any, .branch("develop"), .branch("master")].shuffled().commonVersionSpecifier)
        XCTAssertNil([.any, .commit("0000000000000000000000000000000000000000"), .commit("1111111111111111111111111111111111111111")].shuffled().commonVersionSpecifier)
        XCTAssertNil([.any, .exactVersion("1.5.0"), .exactVersion("1.5.1")].shuffled().commonVersionSpecifier)
        XCTAssertNil([.any, .exactVersion("1.5.0"), .upToNextMajor("1.6.2")].shuffled().commonVersionSpecifier)
        XCTAssertNil([.any, .exactVersion("1.5.0"), .minimumVersion("1.6.7")].shuffled().commonVersionSpecifier)
        XCTAssertNil([.any, .upToNextMajor("3.5.0"), .upToNextMajor("4.9.5")].shuffled().commonVersionSpecifier)
        XCTAssertNil([.any, .minimumVersion("3.0.4"), .upToNextMajor("2.5.0")].shuffled().commonVersionSpecifier)
        XCTAssertNil([.any, .minimumVersion("2.8.4"), .upToNextMajor("1.5.0")].shuffled().commonVersionSpecifier)
        XCTAssertNil([.exactVersion("2.0.0"), .minimumVersion("2.0.4"), .minimumVersion("1.5.0")].shuffled().commonVersionSpecifier)
        XCTAssertNil([.exactVersion("3.10.0"), .upToNextMajor("2.5.0"), .upToNextMajor("3.9.5")].shuffled().commonVersionSpecifier)
        XCTAssertNil([.exactVersion("3.7.0"), .minimumVersion("2.0.4"), .upToNextMajor("2.5.0")].shuffled().commonVersionSpecifier)
    }
}

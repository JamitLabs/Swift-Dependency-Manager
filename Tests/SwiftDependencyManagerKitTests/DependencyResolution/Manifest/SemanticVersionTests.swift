@testable import SwiftDependencyManagerKit
import XCTest

class SemanticVersionTests: XCTestCase {
    func testInit() {
        let zero = SemanticVersion(string: "0.0.0")!
        XCTAssertEqual(zero.major, 0)
        XCTAssertEqual(zero.minor, 0)
        XCTAssertEqual(zero.patch, 0)
        XCTAssertEqual(zero.preReleaseIdentifiers, nil)
        XCTAssertEqual(zero.metadata, nil)

        let vPrefix = SemanticVersion(string: "v2.7.3")!
        XCTAssertEqual(vPrefix.major, 2)
        XCTAssertEqual(vPrefix.minor, 7)
        XCTAssertEqual(vPrefix.patch, 3)
        XCTAssertEqual(vPrefix.preReleaseIdentifiers, nil)
        XCTAssertEqual(vPrefix.metadata, nil)

        let noPatch = SemanticVersion(string: "1.5")!
        XCTAssertEqual(noPatch.major, 1)
        XCTAssertEqual(noPatch.minor, 5)
        XCTAssertEqual(noPatch.patch, 0)
        XCTAssertEqual(noPatch.preReleaseIdentifiers, nil)
        XCTAssertEqual(noPatch.metadata, nil)

        let preRelease = SemanticVersion(string: "04.0.0-alpha.1")!
        XCTAssertEqual(preRelease.major, 4)
        XCTAssertEqual(preRelease.minor, 0)
        XCTAssertEqual(preRelease.patch, 0)
        XCTAssertEqual(preRelease.preReleaseIdentifiers, ["alpha", "1"])
        XCTAssertEqual(preRelease.metadata, nil)

        let metadata = SemanticVersion(string: "5.11.01+20130313144700")!
        XCTAssertEqual(metadata.major, 5)
        XCTAssertEqual(metadata.minor, 11)
        XCTAssertEqual(metadata.patch, 1)
        XCTAssertEqual(metadata.preReleaseIdentifiers, nil)
        XCTAssertEqual(metadata.metadata, "20130313144700")

        let noPatchPreReleaseMetadata = SemanticVersion(string: "17.104-alpha.beta.2+exp.sha.5114f85")!
        XCTAssertEqual(noPatchPreReleaseMetadata.major, 17)
        XCTAssertEqual(noPatchPreReleaseMetadata.minor, 104)
        XCTAssertEqual(noPatchPreReleaseMetadata.patch, 0)
        XCTAssertEqual(noPatchPreReleaseMetadata.preReleaseIdentifiers, ["alpha", "beta", "2"])
        XCTAssertEqual(noPatchPreReleaseMetadata.metadata, "exp.sha.5114f85")

        let nonPreRelease = SemanticVersion(string: "1.0.0+sha.5114f85-alpha.2")!
        XCTAssertEqual(nonPreRelease.major, 1)
        XCTAssertEqual(nonPreRelease.minor, 0)
        XCTAssertEqual(nonPreRelease.patch, 0)
        XCTAssertEqual(nonPreRelease.preReleaseIdentifiers, nil)
        XCTAssertEqual(nonPreRelease.metadata, "sha.5114f85-alpha.2")

        XCTAssertNil(SemanticVersion(string: "1"))
        XCTAssertNil(SemanticVersion(string: "1.0.0-"))
        XCTAssertNil(SemanticVersion(string: "1.0.0+"))
        XCTAssertNil(SemanticVersion(string: "1.0.0-+"))
        XCTAssertNil(SemanticVersion(string: "ver1.0.0"))
    }

    func testDescription() {
        ["0.0.0", "2.7.3", "4.0.0-alpha.1", "5.11.1+20130313144700", "17.104.0-alpha.beta.2+exp.sha.5114f85"].forEach {
            XCTAssertEqual(SemanticVersion(string: $0)!.description, $0)
        }

        XCTAssertEqual(SemanticVersion(string: "1.5")!.description, "1.5.0")
        XCTAssertEqual(SemanticVersion(string: "v2.7.3")!.description, "2.7.3")
        XCTAssertEqual(SemanticVersion(string: "05.017.0049")!.description, "5.17.49")
    }
}

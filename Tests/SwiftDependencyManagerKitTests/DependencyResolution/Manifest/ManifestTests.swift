@testable import SwiftDependencyManagerKit
import XCTest

class ManifestTests: XCTestCase {
    func testInitWithFileContents() {
        let manifestContents: String = """
            [[dependencies]]
            name = "HandySwift"
            gitPath = "https://github.com/Flinesoft/HandySwift.git"
            version = "any"

            [[dependencies]]
            name = "HandyUIKit"
            gitPath = "https://github.com/Flinesoft/HandyUIKit.git"
            version = "upToNextMajor:1.8.0"
            """
        if let manifest = mungo.make({ try Manifest(fileContents: manifestContents) }) {
            XCTAssertEqual(manifest.products.count, 0)
            XCTAssertEqual(manifest.dependencies.count, 2)

            XCTAssertEqual(manifest.dependencies[0].name, "HandySwift")
            XCTAssertEqual(manifest.dependencies[0].gitPath, "https://github.com/Flinesoft/HandySwift.git")
            XCTAssertEqual(manifest.dependencies[0].version, .any)

            XCTAssertEqual(manifest.dependencies[1].name, "HandyUIKit")
            XCTAssertEqual(manifest.dependencies[1].gitPath, "https://github.com/Flinesoft/HandyUIKit.git")
            XCTAssertEqual(manifest.dependencies[1].version, .upToNextMajor("1.8.0"))
        }
    }

    func testInitSimpleFrameworkManifest() {
        let manifestContents: String = """
            [[products]]
            name = "CSVImporter"

            [[dependencies]]
            name = "HandySwift"
            gitPath = "https://github.com/Flinesoft/HandySwift.git"
            version = "commit:0000000000000000000000000000000000000000"

            [[dependencies]]
            name = "HandyUIKit"
            gitPath = "https://github.com/Flinesoft/HandyUIKit.git"
            version = "minimumVersion:1.4.4"
            """
        if let manifest = mungo.make({ try Manifest(fileContents: manifestContents) }) {
            XCTAssertEqual(manifest.products.count, 1)
            XCTAssertEqual(manifest.dependencies.count, 2)

            XCTAssertEqual(manifest.products[0].name, "CSVImporter")
            XCTAssertEqual(manifest.products[0].paths, nil)
            XCTAssertEqual(manifest.products[0].dependencies, nil)

            XCTAssertEqual(manifest.dependencies[0].name, "HandySwift")
            XCTAssertEqual(manifest.dependencies[0].gitPath, "https://github.com/Flinesoft/HandySwift.git")
            XCTAssertEqual(manifest.dependencies[0].version, .commit("0000000000000000000000000000000000000000"))

            XCTAssertEqual(manifest.dependencies[1].name, "HandyUIKit")
            XCTAssertEqual(manifest.dependencies[1].gitPath, "https://github.com/Flinesoft/HandyUIKit.git")
            XCTAssertEqual(manifest.dependencies[1].version, .minimumVersion("1.4.4"))
        }
    }


    func testMakeKitFrameworkManifest() {
        let manifestContents: String = """
            [[products]]
            name = "CSVImporter"
            paths = ["Sources/CSVImporter"]
            dependencies = ["CSVImporterKit"]

            [[products]]
            name = "CSVImporterKit"
            paths = ["Sources/CSVImporterKit"]
            dependencies = ["HandySwift", "HandyUIKit"]

            [[dependencies]]
            name = "HandySwift"
            gitPath = "https://github.com/Flinesoft/HandySwift.git"
            version = "branch:master"

            [[dependencies]]
            name = "HandyUIKit"
            gitPath = "https://github.com/Flinesoft/HandyUIKit.git"
            version = "exactVersion:1.9.1"
            """
        if let manifest = mungo.make({ try Manifest(fileContents: manifestContents) }) {
            XCTAssertEqual(manifest.products.count, 2)
            XCTAssertEqual(manifest.dependencies.count, 2)

            XCTAssertEqual(manifest.products[0].name, "CSVImporter")
            XCTAssertEqual(manifest.products[0].paths, ["Sources/CSVImporter"])
            XCTAssertEqual(manifest.products[0].dependencies, ["CSVImporterKit"])

            XCTAssertEqual(manifest.products[1].name, "CSVImporterKit")
            XCTAssertEqual(manifest.products[1].paths, ["Sources/CSVImporterKit"])
            XCTAssertEqual(manifest.products[1].dependencies, ["HandySwift", "HandyUIKit"])

            XCTAssertEqual(manifest.dependencies[0].name, "HandySwift")
            XCTAssertEqual(manifest.dependencies[0].gitPath, "https://github.com/Flinesoft/HandySwift.git")
            XCTAssertEqual(manifest.dependencies[0].version, .branch("master"))

            XCTAssertEqual(manifest.dependencies[1].name, "HandyUIKit")
            XCTAssertEqual(manifest.dependencies[1].gitPath, "https://github.com/Flinesoft/HandyUIKit.git")
            XCTAssertEqual(manifest.dependencies[1].version, .exactVersion("1.9.1"))
        }
    }

    func testFileContentsAppManifest() {
        let manifestContents: String = """
            [[dependencies]]
            name = "HandySwift"
            gitPath = "https://github.com/Flinesoft/HandySwift.git"
            version = "any"

            [[dependencies]]
            name = "HandyUIKit"
            gitPath = "https://github.com/Flinesoft/HandyUIKit.git"
            version = "upToNextMajor:1.8.0"
            """
        if let manifest = mungo.make({ try Manifest(fileContents: manifestContents) }) {
            XCTAssertEqual(manifest.toFileContents(), manifestContents)
        }
    }

    func testFileContentsSimpleFrameworkManifest() {
        let manifestContents: String = """
            [[products]]
            name = "CSVImporter"

            [[dependencies]]
            name = "HandySwift"
            gitPath = "https://github.com/Flinesoft/HandySwift.git"
            version = "commit:0000000000000000000000000000000000000000"

            [[dependencies]]
            name = "HandyUIKit"
            gitPath = "https://github.com/Flinesoft/HandyUIKit.git"
            version = "minimumVersion:1.4.4"
            """
        if let manifest = mungo.make({ try Manifest(fileContents: manifestContents) }) {
            XCTAssertEqual(manifest.toFileContents(), manifestContents)
        }
    }


    func testFileContentsKitFrameworkManifest() {
        let manifestContents: String = """
            [[products]]
            name = "CSVImporter"
            paths = ["Sources/CSVImporter"]
            dependencies = ["CSVImporterKit"]

            [[products]]
            name = "CSVImporterKit"
            paths = ["Sources/CSVImporterKit"]
            dependencies = ["HandySwift", "HandyUIKit"]

            [[dependencies]]
            name = "HandySwift"
            gitPath = "https://github.com/Flinesoft/HandySwift.git"
            version = "branch:master"

            [[dependencies]]
            name = "HandyUIKit"
            gitPath = "https://github.com/Flinesoft/HandyUIKit.git"
            version = "exactVersion:1.9.1"
            """
        if let manifest = mungo.make({ try Manifest(fileContents: manifestContents) }) {
            XCTAssertEqual(manifest.toFileContents(), manifestContents)
        }
    }
}

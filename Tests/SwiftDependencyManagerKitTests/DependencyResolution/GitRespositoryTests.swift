@testable import SwiftDependencyManagerKit
import XCTest

class GitRespositoryTests: XCTestCase {
    func testLatestCompatibleCommit() {
        let repo = GitRepository(path: "https://github.com/Flinesoft/HandySwift.git", branch: "productive")
        XCTAssertEqual(try repo.latestCompatibleCommit(forVersion: .any).count, 40)
        XCTAssertEqual(try repo.latestCompatibleCommit(forVersion: .branch("productive")).count, 40)
        XCTAssertEqual(try repo.latestCompatibleCommit(forVersion: .commit("bbbcebc02bf872d791d0fcddab5bd2eb6712a6eb")), "bbbcebc02bf872d791d0fcddab5bd2eb6712a6eb")
        XCTAssertEqual(try repo.latestCompatibleCommit(forVersion: .minimumVersion("2.5.0")).count, 40)
        XCTAssertEqual(try repo.latestCompatibleCommit(forVersion: .exactVersion("2.0.0")), "47b3bd7dc2063b7b0c6e4ccb22394a16c10fe653")
        XCTAssertEqual(try repo.latestCompatibleCommit(forVersion: .upToNextMajor("1.0.0")), "84d4a6bccc9360828f32d5c5c288cf5547c77537")
    }

    func testFetchManifest() {
        let repo = GitRepository(path: "https://github.com/Flinesoft/HandySwift.git", branch: "work/sdm")
        let manifest = try! repo.fetchManifest(commit: "d3925b468bdc5ea0d2bef61e773c8de689516702")

        XCTAssertEqual(manifest.products.count, 1)
        XCTAssertEqual(manifest.dependencies.count, 0)

        XCTAssertEqual(manifest.products[0].name, "HandySwift")
        XCTAssertEqual(manifest.products[0].paths, ["Frameworks/HandySwift"])
    }
}

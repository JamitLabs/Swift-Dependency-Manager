@testable import SwiftDependencyManagerKit
import XCTest

class GitRespositoryTests: XCTestCase {
    func testlatestCompatibleCommit() {
        let repo = GitRepository(path: "https://github.com/Flinesoft/HandySwift.git")
        XCTAssertEqual(try repo.latestCompatibleCommit(forVersion: .any).count, 40)
        XCTAssertEqual(try repo.latestCompatibleCommit(forVersion: .exactVersion("2.0.0")), "47b3bd7dc2063b7b0c6e4ccb22394a16c10fe653")
        XCTAssertEqual(try repo.latestCompatibleCommit(forVersion: .upToNextMajor("1.0.0")), "84d4a6bccc9360828f32d5c5c288cf5547c77537")
    }
}

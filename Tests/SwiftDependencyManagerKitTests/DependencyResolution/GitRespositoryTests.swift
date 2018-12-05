@testable import SwiftDependencyManagerKit
import XCTest

class GitRespositoryTests: XCTestCase {
    func testFetchTags() {
        let repo = GitRepository(path: "https://github.com/Flinesoft/HandySwift.git")
        let tags = repo.fetchTags()
        XCTAssertEqual(tags, [])
    }
}

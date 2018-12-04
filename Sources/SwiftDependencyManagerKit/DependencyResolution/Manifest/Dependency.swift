import Foundation
import PromiseKit

struct Dependency: Equatable, Codable {
    public let name: String
    public let gitPath: String
    public let version: VersionSpecifier

    public init(name: String, gitPath: String, version: VersionSpecifier) {
        self.name = name
        self.gitPath = gitPath
        self.version = version
    }

    func fetchManifest() -> Promise<Manifest> {
        let gitRepo = GitRepository(path: gitPath)

        return firstly {
            gitRepo.latestCompatibleCommit(forVersion: version)
        }.then { commit in
            gitRepo.fetchManifest(commit: commit)
        }
    }
}

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
        return firstly {
            let branch: String? = {
                guard case let VersionSpecifier.branch(branch) = version else { return nil }
                return branch
            }()

            return Guarantee.value(GitRepository(path: gitPath, branch: branch))
        }.then { (gitRepo: GitRepository) -> Promise<Manifest> in
            let commit = try gitRepo.latestCompatibleCommit(forVersion: self.version)
            return Promise.value(try gitRepo.fetchManifest(commit: commit))
        }
    }
}

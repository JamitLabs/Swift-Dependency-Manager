import Foundation
import MungoHealer
import PromiseKit
import Clibgit2

struct GitRepository {
    let path: String

    func latestCompatibleCommit(forVersion versionSpecifier: VersionSpecifier) -> Promise<String> {
        return Promise { seal in
            switch versionSpecifier {
            case .any:
                let tags = fetchTags()
                guard let latestVersion = tags.compactMap({ SemanticVersion(rawValue: $0) }).max() else {
                    seal.reject(MungoError(source: .invalidUserInput, message: "Could not find any release tag."))
                    return
                }

                let latestVersionTag = tags.first { SemanticVersion(rawValue: $0) == latestVersion }!
                print("TODO: return commit for tag \(latestVersionTag)")

            case let .exactVersion(version):
                break
                // TODO: return commit of git tag

            case let .minimumVersion(version):
                break
                // TODO: return latest release in case bigger than min version

            case let .upToNextMajor(version):
                break
                // TODO: return latest minor/patch release within given major version if existent and bigger than version

            case let .branch(branch):
                break
                // TODO: return latest commit on branch

            case let .commit(commit):
                seal.fulfill(commit)
            }
        }
    }

    func fetchManifest(commit: String) -> Promise<Manifest> {
        return Promise { seal in
            // TODO: not yet implemented
        }
    }

    private func fetchTags() -> [String] {
        let repoManager = RepositoryManager()
        let repo = try! Repository(openAt: URL(string: path)!, manager: repoManager)
        let tags = Tags(repository: repo)
        return tags.names()
    }
}

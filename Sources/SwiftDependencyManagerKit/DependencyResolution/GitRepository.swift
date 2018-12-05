import Foundation
import HandySwift
import MungoHealer
import PromiseKit
import Clibgit2

class GitRepository {
    private let path: String
    private let localRepository: Git.Repository

    init(path: String) {
        let remoteUrl = URL(string: path)!
        let randomDirName = String(randomWithLength: 8, allowedCharactersType: .alphaNumeric)
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(randomDirName)

        self.path = path
        self.localRepository = Git.shared.clone(from: remoteUrl, to: tempDir)
    }

    func latestCompatibleCommit(forVersion versionSpecifier: VersionSpecifier) throws -> String {
        switch versionSpecifier {
        case .any:
            let tags = self.localRepository.tags()
            guard let latestVersion = tags.compactMap({ SemanticVersion(rawValue: $0) }).max() else {
                throw MungoError(source: .invalidUserInput, message: "Could not find any release tag.")
            }

            let latestVersionTag = tags.first { SemanticVersion(rawValue: $0) == latestVersion }!
            return localRepository.commitOID(forTag: latestVersionTag).sha()!

        case let .exactVersion(version):
            let tags = self.localRepository.tags()
            print(version)
            guard let matchingTag = tags.first(where: { SemanticVersion(rawValue: $0) == version }) else {
                throw MungoError(source: .invalidUserInput, message: "Could not find any release tag matching version '\(version)'.")
            }

            return localRepository.commitOID(forTag: matchingTag).sha()!

        case let .minimumVersion(version):
            let tags = self.localRepository.tags()
            guard let latestMatchingVersion = tags.compactMap({ SemanticVersion(rawValue: $0) }).filter({ $0 >= version }).max() else {
                throw MungoError(source: .invalidUserInput, message: "Could not find any release tag matching minimum version '\(version)'.")
            }

            let latestVersionTag = tags.first { SemanticVersion(rawValue: $0) == latestMatchingVersion }!
            return localRepository.commitOID(forTag: latestVersionTag).sha()!

        case let .upToNextMajor(version):
            let tags = self.localRepository.tags()
            guard let latestMatchingVersion = tags.compactMap({ SemanticVersion(rawValue: $0) }).filter({ $0.major == version.major && $0 >= version }).max() else {
                throw MungoError(source: .invalidUserInput, message: "Could not find any release tag matching up to next major version '\(version)'.")
            }

            let latestVersionTag = tags.first { SemanticVersion(rawValue: $0) == latestMatchingVersion }!
            return localRepository.commitOID(forTag: latestVersionTag).sha()!

        case let .branch(branch):
            // TODO: return latest commit on branch
            return ""

        case let .commit(commit):
            // TODO: check if commit actually exists
            return commit
        }
    }

    func fetchManifest(commit: String) -> Promise<Manifest> {
        return Promise { seal in
            // TODO: not yet implemented
        }
    }
}

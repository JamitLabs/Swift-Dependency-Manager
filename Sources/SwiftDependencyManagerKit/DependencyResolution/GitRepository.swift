import Foundation
import HandySwift
import MungoHealer
import PromiseKit
import Clibgit2

class GitRepository {
    private let path: String
    private let localRepository: Git.Repository

    init(path: String, branch: String?) {
        let remoteUrl = URL(string: path)!
        let randomDirName = String(randomWithLength: 8, allowedCharactersType: .alphaNumeric)
        let tempDir: URL = {
            if #available(OSX 10.12, *) {
                return FileManager.default.temporaryDirectory.appendingPathComponent(randomDirName)
            } else {
                return URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(randomDirName)
            }
        }()


        self.path = path
        self.localRepository = Git.shared.clone(from: remoteUrl, to: tempDir, branch: branch)
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
            return localRepository.commitOID(forBranch: branch).sha()!

        case let .commit(commit):
            return try! OID(withSha: commit).sha()!
        }
    }

    func fetchManifest(commit: String) throws -> Manifest {
        localRepository.checkout(commit: commit)

        if localRepository.fileExists(Manifest.fileName) {
            let fileContents = try localRepository.contents(of: Manifest.fileName)
            return try Manifest.make(fileContents: fileContents)
        } else if localRepository.fileExists(Cartfile.fileName) {
            let fileContents = try localRepository.contents(of: Cartfile.fileName)
            let productName = localRepository.remoteUrl.lastPathComponent.replacingOccurrences(of: ".git", with: "")
            return try Cartfile.makeManifest(fileContents: fileContents, productName: productName)
        } else {
            let productName = localRepository.remoteUrl.lastPathComponent.replacingOccurrences(of: ".git", with: "")
            return Manifest(products: [Product(name: productName)], dependencies: [])
        }
    }
}

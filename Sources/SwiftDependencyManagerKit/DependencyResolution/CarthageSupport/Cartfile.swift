import Foundation
import HandySwift
import Utility

enum CartfileError: Error {
    case unsupportedVersionSpecifier(String)
}

struct Cartfile {
    private typealias GitHubEntry = (user: String, repository: String, version: String)
    private typealias GitEntry = (gitPath: String, version: String)

    let productName: String
    let dependencies: [Dependency]

    init(productName: String, fileContents: String) throws {
        var dependencies: [Dependency] = []

        dependencies += Cartfile.gitHubEntries(in: fileContents).map {
            return Dependency(
                name: $0.repository,
                gitPath: "https://github.com/\($0.user)/\($0.repository).git",
                version: Cartfile.versionSpecifier(forVersion: $0.version)
            )
        }

        dependencies += Cartfile.gitEntries(in: fileContents).map {
            return Dependency(
                name: URL(string: $0.gitPath)!.lastPathComponent.replacingOccurrences(of: ".git", with: ""),
                gitPath: $0.gitPath,
                version: Cartfile.versionSpecifier(forVersion: $0.version)
            )
        }

        self.productName = productName
        self.dependencies = dependencies
    }

    func toManifest() -> Manifest {
        return Manifest(products: [Product(name: productName)], dependencies: dependencies)
    }

    private static func gitHubEntries(in contents: String) -> [GitHubEntry] {
        let gitHubRegex = try! Regex("github \"([^/\"]+)/([^/\"]+)\" *([^\\n]*)")

        return gitHubRegex.matches(in: contents).map { match in
            return (user: match.captures[0]!, repository: match.captures[1]!, version: match.captures[2]!)
        }
    }

    private static func gitEntries(in contents: String) -> [GitEntry] {
        let gitRegex = try! Regex("git(?:hub)? \"((?:git|file|https):[^\"]+)\" *([^\\n]*)")

        return gitRegex.matches(in: contents).map { match in
            return (gitPath: match.captures[0]!, version: match.captures[1]!)
        }
    }

    private static func versionSpecifier(forVersion version: String) -> VersionSpecifier {
        if version.isBlank {
            return VersionSpecifier.any
        } else if
            let versionString = try! Regex("~>\\s*(\\S+)").firstMatch(in: version)?.captures[0],
            let semanticVersion = Version(string: versionString)
        {
            return VersionSpecifier.upToNextMajor(semanticVersion)
        } else if
            let versionString = try! Regex(">=\\s*(\\S+)").firstMatch(in: version)?.captures[0],
            let semanticVersion = Version(string: versionString)
        {
            return VersionSpecifier.minimumVersion(semanticVersion)
        } else if
            let versionString = try! Regex("==\\s*(\\S+)").firstMatch(in: version)?.captures[0],
            let semanticVersion = Version(string: versionString)
        {
            return VersionSpecifier.exactVersion(semanticVersion)
        } else if let commit = try! Regex("([0-9a-f]{40})").firstMatch(in: version)?.captures[0] {
            return VersionSpecifier.commit(commit)
        } else {
            return VersionSpecifier.branch(version.stripped())
        }
    }
}

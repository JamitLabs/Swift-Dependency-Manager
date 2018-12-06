import Foundation
import HandySwift

enum CartfileError: Error {
    case unsupportedVersionSpecifier(String)
}

struct Cartfile {
    private typealias GitHubEntry = (user: String, repository: String, version: String)
    private typealias GitEntry = (gitPath: String, version: String)

    static let fileName = "Cartfile"

    static func makeManifest(fileContents: String, productName: String) throws -> Manifest {
        var dependencies: [Dependency] = []

        dependencies += gitHubEntries(in: fileContents).map {
            return Dependency(
                name: $0.repository,
                gitPath: "https://github.com/\($0.user)/\($0.repository).git",
                version: versionSpecifier(forVersion: $0.version)
            )
        }

        dependencies += gitEntries(in: fileContents).map {
            return Dependency(
                name: URL(string: $0.gitPath)!.lastPathComponent.replacingOccurrences(of: ".git", with: ""),
                gitPath: $0.gitPath,
                version: versionSpecifier(forVersion: $0.version)
            )
        }

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
            let semanticVersion = SemanticVersion(rawValue: versionString)
        {
            return VersionSpecifier.upToNextMajor(semanticVersion)
        } else if
            let versionString = try! Regex(">=\\s*(\\S+)").firstMatch(in: version)?.captures[0],
            let semanticVersion = SemanticVersion(rawValue: versionString)
        {
            return VersionSpecifier.minimumVersion(semanticVersion)
        } else if
            let versionString = try! Regex("==\\s*(\\S+)").firstMatch(in: version)?.captures[0],
            let semanticVersion = SemanticVersion(rawValue: versionString)
        {
            return VersionSpecifier.exactVersion(semanticVersion)
        } else if let commit = try! Regex("([0-9a-f]{40})").firstMatch(in: version)?.captures[0] {
            return VersionSpecifier.commit(commit)
        } else {
            return VersionSpecifier.branch(version.stripped())
        }
    }
}

import Foundation
import HandySwift
import PackageManifest

// swiftlint:disable force_try

enum CartfileParserError: Error {
    case unexpectedVersionSpecifier
}

class CartfileParser {
    private typealias GitHubEntry = (user: String, repository: String, version: String)

    private let contents: String

    init(contents: String) {
        self.contents = contents
    }

    func packageManifest(packageName: String) -> PackageManifest {
        let gitHubRegex = try! Regex("github \"([^/\"]+)/([^/\"]+)\" *([^\\n]*)")

        let gitHubEntries: [GitHubEntry] = gitHubRegex.matches(in: contents).map { match in
            return (user: match.captures[0]!, repository: match.captures[1]!, version: match.captures[2]!)
        }

        let dependencies: [Dependency] = gitHubEntries.map { gitHubEntry in
            return Dependency(
                name: gitHubEntry.repository,
                gitPath: "https://github.com/\(gitHubEntry.user)/\(gitHubEntry.repository).git",
                version: try! versionSpecifier(for: gitHubEntry.version)
            )
        }

        return PackageManifest(name: packageName, dependencies: dependencies)
    }

    private func versionSpecifier(for version: String) throws -> VersionSpecifier {
        if version.isBlank {
            return .latest
        } else if let match = (try! Regex("~> *(\\S+)")).firstMatch(in: version) {
            return VersionSpecifier.compatibleWith(match.captures[0]!)
        } else if let match = (try! Regex("\"([0-9a-f]{40})\"")).firstMatch(in: version) {
            return VersionSpecifier.revision(match.captures[0]!)
        } else if let match = (try! Regex("\"(\\S+)\"")).firstMatch(in: version) {
            return VersionSpecifier.branch(match.captures[0]!)
        } else if let match = (try! Regex("== (\\S+)")).firstMatch(in: version) {
            return VersionSpecifier.exact(match.captures[0]!)
        } else if let match = (try! Regex(">= (\\S+)")).firstMatch(in: version) {
            return VersionSpecifier.minimum(match.captures[0]!)
        } else {
            throw CartfileParserError.unexpectedVersionSpecifier
        }
    }
}

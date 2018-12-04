import Foundation
import HandySwift

enum VersionSpecifier: RawRepresentable, Codable, Equatable {
    case any
    case commit(String) // TODO: clearly document that framework releases should never include a commit based dependency version specifier
    case branch(String) // TODO: clearly document that framework releases should never include a branch based dependency version specifier
    case exactVersion(SemanticVersion) // TODO: document that .upToNextMajor should be used instead of this whenever possible
    case minimumVersion(SemanticVersion)
    case upToNextMajor(SemanticVersion)

    typealias RawValue = String

    var rawValue: String {
        switch self {
        case .any:
            return "any"

        case let .commit(hash):
            return "commit:\(hash)"

        case let .branch(branchName):
            return "branch:\(branchName)"

        case let .exactVersion(version):
            return "exactVersion:\(version.rawValue)"

        case let .minimumVersion(version):
            return "minimumVersion:\(version.rawValue)"

        case let .upToNextMajor(version):
            return "upToNextMajor:\(version.rawValue)"
        }
    }

    init?(carthageSpecifier: String) {
        return nil // TODO: not yet implemented
    }

    init?(rawValue: VersionSpecifier.RawValue) {
        let getRawValueString: () -> String = { rawValue.components(separatedBy: ":")[1] }
        let getRawValueVersion: () -> SemanticVersion? = { SemanticVersion(rawValue: getRawValueString()) }

        switch rawValue {
        case "any":
            self = .any

        case _ where rawValue.hasPrefix("commit:"):
            self = .commit(getRawValueString())

        case _ where rawValue.hasPrefix("branch:"):
            self = .branch(getRawValueString())

        case _ where rawValue.hasPrefix("exactVersion:"):
            guard let version = getRawValueVersion() else { return nil }
            self = .exactVersion(version)

        case _ where rawValue.hasPrefix("minimumVersion:"):
            guard let version = getRawValueVersion() else { return nil }
            self = .minimumVersion(version)

        case _ where rawValue.hasPrefix("upToNextMajor:"):
            guard let version = getRawValueVersion() else { return nil }
            self = .upToNextMajor(version)

        default:
            return nil
        }
    }
}

extension Collection where Element == VersionSpecifier {
    var commonVersionSpecifier: VersionSpecifier? {
        guard var temporaryResult: VersionSpecifier = first else { return nil }

        for semanticVersion in self {
            guard let commonVersionSpecifier = commonVersionSpecifier(lhs: temporaryResult, rhs: semanticVersion) else { return nil }
            temporaryResult = commonVersionSpecifier
        }

        return temporaryResult
    }

    private func commonVersionSpecifier(lhs: VersionSpecifier, rhs: VersionSpecifier) -> VersionSpecifier? {
        guard lhs != rhs else { return lhs }

        switch (lhs, rhs) {
        case let (.any, moreSpecificVersionSpecifier), let (moreSpecificVersionSpecifier, .any):
            return moreSpecificVersionSpecifier

        case let (.minimumVersion(minimumVersion), .exactVersion(exactVersion)), let (.exactVersion(exactVersion), .minimumVersion(minimumVersion)):
            guard exactVersion >= minimumVersion else { return nil }
            return .exactVersion(exactVersion)

        case let (.upToNextMajor(upToNextMajorVersion), .exactVersion(exactVersion)), let (.exactVersion(exactVersion), .upToNextMajor(upToNextMajorVersion)):
            guard exactVersion >= upToNextMajorVersion && exactVersion.major == upToNextMajorVersion.major else { return nil }
            return .exactVersion(exactVersion)

        case let (.upToNextMajor(upToNextMajorVersion), .minimumVersion(minimumVersion)), let (.minimumVersion(minimumVersion), .upToNextMajor(upToNextMajorVersion)):
            guard minimumVersion.major <= upToNextMajorVersion.major else { return nil }

            if minimumVersion < upToNextMajorVersion {
                return .upToNextMajor(upToNextMajorVersion)
            } else {
                return .upToNextMajor(minimumVersion)
            }

        case let (.minimumVersion(lhsMinimumVersion), .minimumVersion(rhsMinimumVersion)):
            return .minimumVersion([lhsMinimumVersion, rhsMinimumVersion].max()!)

        case let (.upToNextMajor(lhsUpToNextMajorVersion), .upToNextMajor(rhsUpToNextMajorVersion)):
            guard lhsUpToNextMajorVersion.major == rhsUpToNextMajorVersion.major else { return nil }
            return .upToNextMajor([lhsUpToNextMajorVersion, rhsUpToNextMajorVersion].max()!)

        default:
            return nil
        }
    }
}

extension SemanticVersion: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self = SemanticVersion(rawValue: value)!
    }
}

import Foundation
import HandySwift

struct SemanticVersion {
    let major: Int
    let minor: Int
    let patch: Int
    let preReleaseIdentifiers: [String]?
    let metadata: String?

    init?(string: String) {
        let regex = try! Regex("\\Av?(\\d+)\\.(\\d+)(?:\\.(\\d+))?(?:-([0-9A-Za-z-\\.]+))?(?:\\+(\\S+))?\\z")
        guard let captures = regex.firstMatch(in: string)?.captures else { return nil }

        self.major = Int(captures[0]!)!
        self.minor = Int(captures[1]!)!
        self.patch = captures[2] != nil ? Int(captures[2]!)! : 0
        self.preReleaseIdentifiers = captures[3]?.components(separatedBy: ".")
        self.metadata = captures[4]
    }
}

extension SemanticVersion: CustomStringConvertible {
    var description: String {
        var description = "\(major).\(minor).\(patch)"

        if let preReleaseIdentifiers = preReleaseIdentifiers {
            description += "-\(preReleaseIdentifiers.joined(separator: "."))"
        }

        if let metadata = metadata {
            description += "+\(metadata)"
        }

        return description
    }
}

extension SemanticVersion: Comparable {
    static func == (lhs: SemanticVersion, rhs: SemanticVersion) -> Bool {
        guard lhs.major == rhs.major else { return false }
        guard lhs.minor == rhs.minor else { return false }
        guard lhs.patch == rhs.patch else { return false }
        return lhs.preReleaseIdentifiers == rhs.preReleaseIdentifiers
    }

    static func < (lhs: SemanticVersion, rhs: SemanticVersion) -> Bool {
        guard lhs.major == rhs.major else { return lhs.major < rhs.major }
        guard lhs.minor == rhs.minor else { return lhs.minor < rhs.minor }
        guard lhs.patch == rhs.patch else { return lhs.patch < rhs.patch }

        switch (lhs.preReleaseIdentifiers, rhs.preReleaseIdentifiers) {
        case (.none, .none), (.none, .some):
            return false

        case (.some, .none):
            return true

        case let (.some(lhsPreReleaseIdentifiers), .some(rhsPreReleaseIdentifiers)):
            let commonRange = 0 ..< min(lhsPreReleaseIdentifiers.count, rhsPreReleaseIdentifiers.count)

            for index in commonRange {
                let (lhsIdentifier, rhsIdentifier) = (lhsPreReleaseIdentifiers[index], rhsPreReleaseIdentifiers[index])

                if let lhsIdentifierInt = Int(lhsIdentifier), let rhsIdentifierInt = Int(rhsIdentifier) {
                    guard lhsIdentifierInt == rhsIdentifierInt else { return lhsIdentifierInt < rhsIdentifierInt }
                } else {
                    guard lhsIdentifier == rhsIdentifier else { return lhsIdentifier < rhsIdentifier }
                }
            }

            return lhsPreReleaseIdentifiers.count < rhsPreReleaseIdentifiers.count
        }
    }
}

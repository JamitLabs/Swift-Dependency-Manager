import Foundation
import HandySwift

struct SemanticVersion: CustomStringConvertible {
    let major: Int
    let minor: Int
    let patch: Int
    let preReleaseIdentifiers: [String]?
    let metadata: String?

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

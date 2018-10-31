import Foundation

public enum VersionSpecifier: Equatable {
    case latest
    case exact(String)
    case minimum(String)
    case compatibleWith(String)
    case branch(String)
    case revision(String)

    func packageManifestSpecifier() -> String {
        switch self { // swiftlint:disable too_much_unindentation
        case .latest:
            return """
                from: "0.0.0"
                """

        case let .exact(version):
            return """
                .exact("\(version)")
                """

        case let .minimum(version):
            return """
                from: "\(version)"
                """

        case let .compatibleWith(version):
            if version.split(separator: ".").count > 2 {
                return """
                    .upToNextMinor(from: "\(version)")
                    """
            } else {
                return """
                    .upToNextMajor(from: "\(version)")
                    """
            }

        case let .branch(version):
            return """
                .branch("\(version)")
                """

        case let .revision(version):
            return """
                .revision("\(version)")
                """
        } // swiftlint:enable too_much_unindentation
    }
}

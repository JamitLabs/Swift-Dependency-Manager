import Foundation

struct Dependency: Equatable, Codable {
    public let name: String
    public let gitPath: String
    public let version: VersionSpecifier

    public init(name: String, gitPath: String, version: VersionSpecifier) {
        self.name = name
        self.gitPath = gitPath
        self.version = version
    }
}

import Foundation

struct ManifestV1_0: Codable {
    public let name: String
    public let dependencies: [Dependency]

    public init(name: String, dependencies: [Dependency]) {
        self.name = name
        self.dependencies = dependencies
    }

    public func write(to path: String) throws {
        try contents().write(toFile: path, atomically: true, encoding: .utf8)
    }

    func contents() -> String {
        return """
        // swift-tools-version:4.2
        import PackageDescription

        let package = Package(
        name: "\(name)",
        products: [
        .library(name: "\(name)", type: .dynamic, targets: ["\(name)"])
        ],
        dependencies: [
        \(dependencies.map { $0.packageManifestEntry() }.joined(separator: "\n        "))
        ],
        targets: [
        .target(
        name: "\(name)",
        dependencies: [
        \(dependencies.map { "\"\($0.name),\"" }.joined(separator: "\n            "))
        ]
        )
        ]
        )

        """
    }
}

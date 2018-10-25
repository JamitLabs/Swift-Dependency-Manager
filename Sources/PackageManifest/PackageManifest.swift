import Foundation

public struct PackageManifest {
    public let name: String
    public let dependencies: [Dependency]

    public func write(to path: String) throws {
        try contents().write(toFile: path, atomically: true, encoding: .utf8)
    }

    private func contents() -> String {
        return """
            // swift-tools-version:4.2
            import PackageDescription

            let package = Package(
                name: "\(name)",
                products: [
                    .library(name: "\(name)", type: .dynamic, targets: ["\(name)"])
                ],
                dependencies: [
                //        .package(url: "https://github.com/Flinesoft/HandySwift.git", .upToNextMajor(from: "2.5.0")),
                //        .package(url: "https://github.com/Flinesoft/HandyUIKit.git", .upToNextMajor(from: "1.6.0"))
                ],
                targets: [
                    .target(
                        name: "NewFrameworkTemplate",
                        dependencies: [
                //                "HandySwift",
                //                "HandyUIKit"
                        ],
                        path: "Frameworks/NewFrameworkTemplate",
                        exclude: ["Frameworks/SupportingFiles"]
                    ),
                    .testTarget(
                        name: "NewFrameworkTemplateTests",
                        dependencies: ["NewFrameworkTemplate"],
                        exclude: ["Tests/SupportingFiles"]
                    )
                ]
            )

            """
    }
}

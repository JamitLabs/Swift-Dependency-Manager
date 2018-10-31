@testable import PackageManifest
import XCTest

final class PackageManifestTests: XCTestCase {
    func testContents() {
        let packageManifest = PackageManifest(
            name: "MyPackage", dependencies: [
                Dependency(name: "HandySwift", gitPath: "https://github.com/Flinesoft/HandySwift.git", version: .compatibleWith("2.6")),
                Dependency(name: "HandyUIKit", gitPath: "https://github.com/Flinesoft/HandyUIKit.git", version: .branch("stable"))
            ]
        )

        let result = packageManifest.contents()
        let expected = """
            // swift-tools-version:4.2
            import PackageDescription

            let package = Package(
                name: "MyPackage",
                products: [
                    .library(name: "MyPackage", type: .dynamic, targets: ["MyPackage"])
                ],
                dependencies: [
                    .package(url: "https://github.com/Flinesoft/HandySwift.git", .upToNextMajor(from: "2.6")),
                    .package(url: "https://github.com/Flinesoft/HandyUIKit.git", .branch("stable")),
                ],
                targets: [
                    .target(
                        name: "MyPackage",
                        dependencies: [
                            "HandySwift,"
                        "HandyUIKit,"
                        ]
                    )
                ]
            )

            """

        XCTAssertEqual(result, expected)
    }
}

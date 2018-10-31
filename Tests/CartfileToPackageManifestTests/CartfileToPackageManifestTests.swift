@testable import CartfileToPackageManifest
import PackageManifest
import TestSupport
import XCTest

final class CartfileToPackageManifestTests: XCTestCase {
    let cartfile = Resource(
        path: "Cartfile",
        contents: """
            # Handy Swift features that didn't make it into the Swift standard library.
            github "Flinesoft/HandySwift" ~> 2.6

            # Handy UI features that should have been part of UIKit in the first place.
            github "Flinesoft/HandyUIKit" >= 1.6.0

            # Modern Swift API for NSUserDefaults
            github "Flinesoft/Imperio" == 3.0.0

            # Error Handler based on localized & healable (recoverable) errors without the overhead of NSError.
            github "JamitLabs/MungoHealer"

            # Global Screen Router. Useful for Custom URL Schemes, Push Notifications, Siri Shortcuts etc.
            github "JamitLabs/Portus" "stable"

            """
    )

    func testConvert() {
        resourcesLoaded([cartfile]) {
            try? CartfileToPackageManifest.shared.convert(in: Resource.baseUrl.path, packageName: "MyPackage")

            let expectedManifestUrl = URL(fileURLWithPath: Resource.baseUrl.path).appendingPathComponent("Package.swift")
            let manifestContents = try? String(contentsOf: expectedManifestUrl)
            let expectedManifestContents = """
                // swift-tools-version:4.2
                import PackageDescription

                let package = Package(
                    name: "MyPackage",
                    products: [
                        .library(name: "MyPackage", type: .dynamic, targets: ["MyPackage"])
                    ],
                    dependencies: [
                        .package(url: "https://github.com/Flinesoft/HandySwift.git", .upToNextMajor(from: "2.6")),
                        .package(url: "https://github.com/Flinesoft/HandyUIKit.git", from: "1.6.0"),
                        .package(url: "https://github.com/Flinesoft/Imperio.git", .exact("3.0.0")),
                        .package(url: "https://github.com/JamitLabs/MungoHealer.git", from: "0.0.0"),
                        .package(url: "https://github.com/JamitLabs/Portus.git", .branch("stable")),
                    ],
                    targets: [
                        .target(
                            name: "MyPackage",
                            dependencies: [
                                "HandySwift,"
                            "HandyUIKit,"
                            "Imperio,"
                            "MungoHealer,"
                            "Portus,"
                            ]
                        )
                    ]
                )

                """

            XCTAssertEqual(manifestContents, expectedManifestContents)
        }
    }
}

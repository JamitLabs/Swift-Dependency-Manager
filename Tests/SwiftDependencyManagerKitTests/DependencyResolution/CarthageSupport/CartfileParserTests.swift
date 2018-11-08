//@testable import SwiftDependencyManagerKit
//import XCTest
//
//final class CartfileParserTests: XCTestCase {
//    func testPackageManifest() {
//        let cartfileParser = CartfileParser(
//            contents: """
//                # Handy Swift features that didn't make it into the Swift standard library.
//                github "Flinesoft/HandySwift" ~> 2.6
//
//                # Handy UI features that should have been part of UIKit in the first place.
//                github "Flinesoft/HandyUIKit" >= 1.6.0
//
//                # Modern Swift API for NSUserDefaults
//                github "Flinesoft/Imperio" == 3.0.0
//
//                # Error Handler based on localized & healable (recoverable) errors without the overhead of NSError.
//                github "JamitLabs/MungoHealer"
//
//                # Global Screen Router. Useful for Custom URL Schemes, Push Notifications, Siri Shortcuts etc.
//                github "JamitLabs/Portus" "stable"
//                """
//        )
//
//        let resultManifest = cartfileParser.packageManifest(packageName: "MyPackage")
//        let expectedManifest = Manifest(
//            name: "MyPackage",
//            dependencies: [
//                Dependency(name: "HandySwift", gitPath: "https://github.com/Flinesoft/HandySwift.git", version: .compatibleWith("2.6")),
//                Dependency(name: "HandyUIKit", gitPath: "https://github.com/Flinesoft/HandyUIKit.git", version: .minimum("1.6.0")),
//                Dependency(name: "Imperio", gitPath: "https://github.com/Flinesoft/Imperio.git", version: .exact("3.0.0")),
//                Dependency(name: "MungoHealer", gitPath: "https://github.com/JamitLabs/MungoHealer.git", version: .latest),
//                Dependency(name: "Portus", gitPath: "https://github.com/JamitLabs/Portus.git", version: .branch("stable"))
//            ]
//        )
//
//        XCTAssertEqual(resultManifest.name, expectedManifest.name)
//        XCTAssertEqual(resultManifest.dependencies, expectedManifest.dependencies)
//    }
//}

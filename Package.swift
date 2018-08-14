// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "SwiftDependencyManager",
    products: [
        .executable(name: "sdm", targets: ["SwiftDependencyManager"]),
        .library(name: "SwiftDependencyManagerKit", targets: ["SwiftDependencyManagerKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/kiliankoe/CLISpinner.git", .upToNextMinor(from: "0.3.5")),
        .package(url: "https://github.com/Flinesoft/HandySwift.git", .upToNextMajor(from: "2.6.0")),
        .package(url: "https://github.com/onevcat/Rainbow.git", .upToNextMajor(from: "3.1.4")),
        .package(url: "https://github.com/jakeheis/SwiftCLI", .upToNextMajor(from: "5.1.2")),
        .package(url: "https://github.com/tuist/xcodeproj.git", .branch("master"))
    ],
    targets: [
        .target(
            name: "SwiftDependencyManager",
            dependencies: ["SwiftDependencyManagerKit"]
        ),
        .target(
            name: "SwiftDependencyManagerKit",
            dependencies: [
                "CLISpinner",
                "HandySwift",
                "Rainbow",
                "SwiftCLI",
                "xcodeproj"
            ]
        ),
        .testTarget(
            name: "SwiftDependencyManagerKitTests",
            dependencies: ["SwiftDependencyManagerKit", "HandySwift"]
        )
    ]
)

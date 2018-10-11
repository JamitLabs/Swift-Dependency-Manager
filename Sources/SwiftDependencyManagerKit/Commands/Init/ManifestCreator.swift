//
//  ManifestCreator.swift
//  SwiftDependencyManagerKit
//
//  Created by Cihat Gündüz on 11.10.18.
//

import Foundation

final class ManifestCreator {
    // MARK: - Stored Type Properties
    static let shared = ManifestCreator()

    // MARK: - Properties
    private let manifestFileName: String = "Package.swift"
    private var manifestFileUrl: URL {
        let currentDirectoryUrl = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        return currentDirectoryUrl.appendingPathComponent(manifestFileName)
    }

    private let initialManifestContents: String = """
        // swift-tools-version:4.2

        import PackageDescription

        let package = Package(
            name: "App",
            dependencies: [
                // .package(url: "https://github.com/Flinesoft/HandySwift.git", .upToNextMajor(from: "2.7.0")),
            ]
        )

        """

    // MARK: - Initializers
    private init() {}

    // MARK: - Instance Methods
    func createInitialManifest() {
        guard !manifestExists() else {
            print("'\(manifestFileName)' already exists.", level: .warning)
            return
        }

        print("Creating initial manifest file at '\(manifestFileName)'", level: .info)
        let contents = initialManifestContents.data(using: .utf8)
        FileManager.default.createFile(atPath: manifestFileUrl.path, contents: contents, attributes: nil)
    }

    private func manifestExists() -> Bool {
        return FileManager.default.fileExists(atPath: manifestFileUrl.path)
    }
}

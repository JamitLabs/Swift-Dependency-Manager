import Basic
import Foundation
import PackageLoading
import PackageModel
import Utility

struct ManifestResource: ManifestResourceProvider {
    let swiftCompiler = AbsolutePath("/Users/Arbeit/.swiftenv/shims/swiftc")
    let libDir = AbsolutePath("/usr/local/lib/")
}

struct SwiftPM {
    static let shared = SwiftPM()

    func updateDependencies() throws {
        let manifest = try loadManifest()
        // TODO: not yet implemented
    }

    func resolveDependencies() throws {
        let manifest = try loadManifest()
        // TODO: not yet implemented
    }

    private func loadManifest() throws -> Manifest {
        let manifestLoader = ManifestLoader(resources: ManifestResource(), isManifestSandboxEnabled: true)
        return try manifestLoader.load(
            package: AbsolutePath(FileManager.default.currentDirectoryPath),
            baseURL: FileManager.default.currentDirectoryPath,
            manifestVersion: .v4_2
        )
    }
}

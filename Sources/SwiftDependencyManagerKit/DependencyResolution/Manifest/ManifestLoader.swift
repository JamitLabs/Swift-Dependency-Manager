import Foundation
import MungoHealer
import PackageLoading

final class ManifestLoader: ManifestLoaderProtocol {
    static func load() throws -> Manifest { // TODO: not yet implemented
        let manifestUrl = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent("Dependencies.toml")

        guard FileManager.default.fileExists(atPath: manifestUrl.path) else {
            throw MungoError(source: .internalInconsistency, message: "Could not find manifest file at path '\(manifestUrl.path)'.")
        }

        let fileContents = try String(contentsOf: manifestUrl)
        return try Manifest(fileContents: fileContents)
    }
}

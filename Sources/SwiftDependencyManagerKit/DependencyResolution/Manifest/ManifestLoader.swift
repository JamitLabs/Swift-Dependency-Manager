import Foundation
import MungoHealer

enum ManifestLoader {
    static func load() throws -> Manifest {
        let manifestUrl = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent("Dependencies.toml")

        guard FileManager.default.fileExists(atPath: manifestUrl.path) else {
            throw MungoError(source: .internalInconsistency, message: "Could not find manifest file at path '\(manifestUrl.path)'.")
        }

        let fileContents = try String(contentsOf: manifestUrl)
        return try Manifest(fileContents: fileContents)
    }
}

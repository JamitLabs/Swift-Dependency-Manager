import Foundation

struct VersionedManifest: Codable {
    let version: ManifestVersion
    let manifest: Data
}

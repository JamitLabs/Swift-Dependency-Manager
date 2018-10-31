import Foundation
import HandySwift

extension FileManager {
    public func removeContentsOfDirectory(at url: URL, options mask: FileManager.DirectoryEnumerationOptions = []) throws {
        guard fileExists(atPath: url.path) else { return }
        for suburl in try contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: mask) {
            try FileManager.default.removeItem(at: suburl)
        }
    }

    public func createFile(atPath path: String, withIntermediateDirectories: Bool, contents: Data?, attributes: [FileAttributeKey: Any]?) throws {
        let directoryUrl = URL(fileURLWithPath: path).deletingLastPathComponent()

        if withIntermediateDirectories && !FileManager.default.fileExists(atPath: directoryUrl.path) {
            try createDirectory(at: directoryUrl, withIntermediateDirectories: true, attributes: attributes)
        }

        createFile(atPath: path, contents: contents, attributes: attributes)
    }
}
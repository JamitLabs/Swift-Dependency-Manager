import Foundation
import MungoHealer

enum CartfileLoader {
    static func load(productName: String) throws -> Cartfile {
        let cartfileUrl = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent("Cartfile")

        guard FileManager.default.fileExists(atPath: cartfileUrl.path) else {
            throw MungoError(source: .internalInconsistency, message: "Could not find Cartfile at path '\(cartfileUrl.path)'.")
        }

        let fileContents = try String(contentsOf: cartfileUrl)
        return try Cartfile(productName: productName, fileContents: fileContents)
    }
}

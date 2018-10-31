import Foundation
import HandySwift

public struct Resource {
    public static let baseUrl = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent(".testResources")

    let path: String
    let contents: String

    var data: Data? {
        return contents.data(using: .utf8)
    }

    public init(path: String, contents: String) {
        self.path = Resource.baseUrl.appendingPathComponent(path).path
        self.contents = contents
    }
}

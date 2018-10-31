import Foundation
import PackageManifest

public class PodspecParser {
    private let contents: String

    public init(contents: String) {
        self.contents = contents
    }

    public func packageManifest(packageName: String) -> PackageManifest {
        // TODO: not yet implemented
        fatalError()
    }
}

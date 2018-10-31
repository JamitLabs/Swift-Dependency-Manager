import Foundation

public struct CartfileToPackageManifest {
    public static let shared = CartfileToPackageManifest()

    public func convert(in directory: String, packageName: String) throws {
        let cartfileUrl = URL(fileURLWithPath: directory).appendingPathComponent("Cartfile")
        let manifestUrl = URL(fileURLWithPath: directory).appendingPathComponent("Package.swift")

        let cartfileContents = try String(contentsOf: cartfileUrl)
        let parser = CartfileParser(contents: cartfileContents)

        let packageManifest = parser.packageManifest(packageName: packageName)
        try packageManifest.write(to: manifestUrl.path)
    }
}

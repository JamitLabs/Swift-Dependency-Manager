import Foundation
import MungoHealer
import PromiseKit
import Toml

struct Manifest {
    private static let fileName = "Dependencies.toml"

    let products: [Product]
    let dependencies: [Dependency]

    static func load() -> Promise<Manifest> {
        return Promise { seal in
//            let manifestUrl = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent(Manifest.fileName)
//            guard FileManager.default.fileExists(atPath: manifestUrl.path) else {
//                seal.reject(MungoError(source: .internalInconsistency, message: "Could not find manifest file at path '\(manifestUrl.path)'."))
//                return
//            }
//
//            guard let manifestToml = try? Toml(contentsOfFile: manifestUrl.path) else {
//                seal.reject(MungoError(source: .invalidUserInput, message: "Could not parse TOML file at path '\(manifestUrl.path)'."))
//                return
//            }
//
//            let products: [Product] = manifestToml.array("products").map { (productToml: Toml) in
//                return Product(
//                    name: productToml.string("name")!,
//                    paths: productToml.array("paths")
//                )
//            }
//
//            let dependencies: [Dependency] = manifestToml.array("dependencies").map { (dependencyToml: Toml) in
//                return Dependency(
//                    name: dependencyToml.string("name"),
//                    gitPath: dependencyToml.string("gitPath"),
//                    version:
//                )
//            }
//
//            return Manifest(products: products, dependencies: dependencies)
        }
    }
}


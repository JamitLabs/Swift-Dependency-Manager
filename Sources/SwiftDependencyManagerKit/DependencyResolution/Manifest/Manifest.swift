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
            let manifestUrl = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent(Manifest.fileName)
            guard FileManager.default.fileExists(atPath: manifestUrl.path) else {
                seal.reject(MungoError(source: .internalInconsistency, message: "Could not find manifest file at path '\(manifestUrl.path)'."))
                return
            }

            guard let manifestToml = try? Toml(contentsOfFile: manifestUrl.path) else {
                seal.reject(MungoError(source: .invalidUserInput, message: "Could not parse TOML file at path '\(manifestUrl.path)'."))
                return
            }

            let productTomls: [Toml] = manifestToml.array("products") ?? []

            var products: [Product] = []
            for productToml in productTomls {
                guard let productName = productToml.string("name") else {
                    seal.reject(MungoError(source: .invalidUserInput, message: "All products in Manifest must have the key `name` specified."))
                    return
                }

                products.append(Product(name: productName, paths: productToml.array("paths")))
            }

            let dependencyTomls: [Toml] = manifestToml.array("dependencies") ?? []

            var dependencies: [Dependency] = []
            for dependencyToml in dependencyTomls {
                guard let name = dependencyToml.string("name") else {
                    seal.reject(MungoError(source: .invalidUserInput, message: "All dependencies in Manifest must have the key `name` specified."))
                    return
                }

                guard let gitPath = dependencyToml.string("gitPath") else {
                    seal.reject(MungoError(source: .invalidUserInput, message: "All dependencies in Manifest must have the key `gitPath` specified."))
                    return
                }

                guard let versionString = dependencyToml.string("version") else {
                    seal.reject(MungoError(source: .invalidUserInput, message: "All dependencies in Manifest must have the key `version` specified."))
                    return
                }

                guard let version = VersionSpecifier(rawValue: versionString) else {
                    seal.reject(MungoError(source: .invalidUserInput, message: "Version specifier '\(versionString)' for dependency '\(name)' is invalid."))
                    return
                }

                dependencies.append(Dependency(name: name, gitPath: gitPath, version: version))
            }

            seal.fulfill(Manifest(products: products, dependencies: dependencies))
        }
    }
}


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

            do {
                let fileContents = try String(contentsOf: manifestUrl)
                let manifest = try self.make(fileContents: fileContents)
                seal.fulfill(manifest)
            } catch {
                seal.reject(error)
            }
        }
    }

    static func make(fileContents: String) throws -> Manifest {
        guard let manifestToml = try? Toml(withString: fileContents) else {
            throw MungoError(source: .invalidUserInput, message: "Could not parse TOML file contents.")
        }

        let productTomls: [Toml] = manifestToml.array("products") ?? []

        var products: [Product] = []
        for productToml in productTomls {
            guard let productName = productToml.string("name") else {
                throw MungoError(source: .invalidUserInput, message: "All products in Manifest must have the key `name` specified.")
            }

            products.append(Product(name: productName, paths: productToml.array("paths"), dependencies: productToml.array("dependencies")))
        }

        let dependencyTomls: [Toml] = manifestToml.array("dependencies") ?? []

        var dependencies: [Dependency] = []
        for dependencyToml in dependencyTomls {
            guard let name = dependencyToml.string("name") else {
                throw MungoError(source: .invalidUserInput, message: "All dependencies in Manifest must have the key `name` specified.")
            }

            guard let gitPath = dependencyToml.string("gitPath") else {
                throw MungoError(source: .invalidUserInput, message: "All dependencies in Manifest must have the key `gitPath` specified.")
            }

            guard let versionString = dependencyToml.string("version") else {
                throw MungoError(source: .invalidUserInput, message: "All dependencies in Manifest must have the key `version` specified.")
            }

            guard let version = VersionSpecifier(rawValue: versionString) else {
                throw MungoError(source: .invalidUserInput, message: "Version specifier '\(versionString)' for dependency '\(name)' is invalid.")
            }

            dependencies.append(Dependency(name: name, gitPath: gitPath, version: version))
        }

        return Manifest(products: products, dependencies: dependencies)
    }
}

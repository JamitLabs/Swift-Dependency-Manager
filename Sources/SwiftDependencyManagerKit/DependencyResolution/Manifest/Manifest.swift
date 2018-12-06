import Foundation
import MungoHealer
import PromiseKit
import Toml

struct Manifest {
    static let fileName = "Dependencies.toml"

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

    func fileContents() -> String {
        let productsContents: [String] = products.map { product in
            var lines: [String] = ["[[products]]"]
            lines.append("name = \"\(product.name)\"")

            if let productPaths = product.paths {
                lines.append("paths = \(productPaths)")
            }

            if let productDependencies = product.dependencies {
                lines.append("dependencies = \(productDependencies)")
            }

            return lines.joined(separator: "\n")
        }

        let dependenciesContents: [String] = dependencies.map { dependency in
            var lines: [String] = ["[[dependencies]]"]

            lines.append("name = \"\(dependency.name)\"")
            lines.append("gitPath = \"\(dependency.gitPath)\"")
            lines.append("version = \"\(dependency.version.rawValue)\"")

            return lines.joined(separator: "\n")
        }

        return (productsContents + dependenciesContents).joined(separator: "\n\n")
    }
}

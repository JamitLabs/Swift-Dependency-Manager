import Foundation

struct Product {
    let name: String
    let paths: [String]?
    let dependencies: [String]?

    init(name: String, paths: [String]? = nil, dependencies: [String]? = nil) {
        self.name = name
        self.paths = paths
        self.dependencies = dependencies
    }

    func dependencies(in manifest: Manifest) -> [Dependency] {
        guard let dependencies = dependencies else {
            return manifest.dependencies
        }

        let directDependencies: [Dependency] = manifest.dependencies.filter { dependencies.contains($0.name) }
        let productDependencies: [Product] = manifest.products.filter { dependencies.contains($0.name) }
        let indirectDependencies: [Dependency] = productDependencies.reduce([]) { $0 + $1.dependencies(in: manifest) }
        return directDependencies + indirectDependencies
    }
}

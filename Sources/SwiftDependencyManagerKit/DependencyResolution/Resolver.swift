import Foundation
import MungoHealer
import PromiseKit

class Resolver {
    var resolvedDependencies: [Dependency] = []

    func resolveDependencies(manifest: Manifest, product: Product) -> Promise<[Dependency]> {
        resolvedDependencies = []
        return recursivelyResolve(manifest: manifest, product: product)
    }

    private func recursivelyResolve(manifest: Manifest, product: Product) -> Promise<[Dependency]> {
        return Promise { seal in
            let productDependencies = product.dependencies(in: manifest)
            self.resolvedDependencies = self.resolvedDependencies.combined(with: productDependencies)

            var lane: Promise<Void> = Promise()

            for dependency in productDependencies {
                lane = lane.then {
                    dependency.fetchManifest()
                }.then { (manifest: Manifest) -> Promise<[Dependency]> in
                    guard let product = manifest.products.first(where: { $0.name == dependency.name }) else {
                        throw MungoError(
                            source: .invalidUserInput,
                            message: "Manifest at \(dependency.gitPath) did not include any product named '\(dependency.name)'."
                        )
                    }

                    return self.recursivelyResolve(manifest: manifest, product: product)
                }.map { (subdependencies: [Dependency]) in
                    self.resolvedDependencies = self.resolvedDependencies.combined(with: subdependencies)
                }
            }

            lane.done {
                seal.fulfill(self.resolvedDependencies)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
}

extension Array where Element == Dependency {
    func combined(with otherArray: [Dependency]) -> [Dependency] {
        var combinedDict: [String: Dependency] = [:]

        for dependency in (self + otherArray) {
            if let existingDependency = combinedDict[dependency.name] {
                if let commonVersion = existingDependency.version.commonVersionSpecifier(with: dependency.version) {
                    combinedDict[dependency.name] = Dependency(name: dependency.name, gitPath: existingDependency.gitPath, version: commonVersion)
                } else {
                    // TODO: show error when versions are not compatible with each other
                }
            } else {
                combinedDict[dependency.name] = dependency
            }
        }

        return Array(combinedDict.values)
    }
}

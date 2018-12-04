import Foundation
import MungoHealer
import PromiseKit

class Resolver {
    let manifest: Manifest
    let product: Product

    init(manifest: Manifest, product: Product) {
        self.manifest = manifest
        self.product = product
    }

    func resolveDependencies() -> Promise<[Dependency]> {
        return Promise { seal in
            var dependencies: [Dependency] = product.dependencies(in: manifest)
            var lane: Promise<Void> = Promise()

            for dependency in dependencies {
                lane = lane.then {
                    dependency.fetchManifest()
                }.map { (manifest: Manifest) in
                    guard let product = manifest.products.first(where: { $0.name == dependency.name }) else {
                        throw MungoError(
                            source: .invalidUserInput,
                            message: "Manifest at \(dependency.gitPath) did not include any product named '\(dependency.name)'."
                        )
                    }

                    let subdependencies = product.dependencies(in: manifest)
                    dependencies.append(contentsOf: subdependencies)
                }
            }

            lane.done {
                seal.fulfill(dependencies)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
}

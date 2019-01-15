import Foundation
import SwiftCLI
import Basic
import PackageGraph
import SourceControl

public class InstallCommand: Command {
    // MARK: - Command
    public let name: String = "install"
    public let shortDescription: String = "Installs the already resolved dependencies"

    // MARK: - Initializers
    public init() {}

    // MARK: - Instance Methods
    public func execute() throws {
        measure("Install Command") {
            let repositoriesPath = AbsolutePath(FileManager.default.currentDirectoryPath.appending("SDM/Repositories"))
            let repositoryProvider = GitRepositoryProvider()

            let manifestLoader = ManifestLoader() // TODO: not yet implemented
            let repositoryManager = RepositoryManager(path: repositoriesPath, provider: repositoryProvider, delegate: self)
            let provider = RepositoryPackageContainerProvider(repositoryManager: repositoryManager, manifestLoader: manifestLoader)

            let resolver = DependencyResolver(provider, self, isPrefetchingEnabled: false, skipUpdate: false)
        }
    }
}

extension InstallCommand: RepositoryManagerDelegate {
    public func fetchingWillBegin(handle: RepositoryManager.RepositoryHandle) {
        // TODO: not yet implemented
    }

    public func fetchingDidFinish(handle: RepositoryManager.RepositoryHandle, error: Swift.Error?) {
        // TODO: not yet implemented
    }

    public func handleWillUpdate(handle: RepositoryManager.RepositoryHandle) {
        // TODO: not yet implemented
    }

    public func handleDidUpdate(handle: RepositoryManager.RepositoryHandle) {
        // TODO: not yet implemented
    }
}

extension InstallCommand: DependencyResolverDelegate {
    public typealias Identifier = RepositoryPackageContainer.Identifier
}

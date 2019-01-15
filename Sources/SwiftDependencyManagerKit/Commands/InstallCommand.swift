import Foundation
import SwiftCLI

public class InstallCommand: Command {
    // MARK: - Command
    public let name: String = "install"
    public let shortDescription: String = "Installs the already resolved dependencies"

    // MARK: - Initializers
    public init() {}

    // MARK: - Instance Methods
    public func execute() throws {
        measure("Install Command") {
            // TODO: not yet implemented
        }
    }
}

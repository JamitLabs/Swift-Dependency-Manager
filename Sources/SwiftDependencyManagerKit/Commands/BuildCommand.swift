import Foundation
import SwiftCLI

public class BuildCommand: Command {
    // MARK: - Command
    public let name: String = "build"
    public let shortDescription: String = "Builds all dependencies"

    // MARK: - Initializers
    public init() {}

    // MARK: - Instance Methods
    public func execute() throws {
        print("Command '\(name)' is not yet implemented.", level: .info)
    }
}

import Foundation
import SwiftCLI

public class CleanCommand: Command {
    // MARK: - Command
    public let name: String = "clean"
    public let shortDescription: String = "Cleans all dependencies"

    // MARK: - Initializers
    public init() {}

    // MARK: - Instance Methods
    public func execute() throws {
        print("Command '\(name)' is not yet implemented.", level: .info)
    }
}

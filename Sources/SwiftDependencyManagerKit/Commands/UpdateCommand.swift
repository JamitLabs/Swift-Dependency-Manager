import Foundation
import SwiftCLI

public class UpdateCommand: Command {
    // MARK: - Command
    public let name: String = "update"
    public let shortDescription: String = "Updates the dependencies"

    // MARK: - Initializers
    public init() {}

    // MARK: - Instance Methods
    public func execute() throws {
        print("Command '\(name)' is not yet implemented.", level: .info)
    }
}

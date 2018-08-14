import Foundation
import SwiftCLI

public class InitCommand: Command {
    // MARK: - Command
    public let name: String = "init"
    public let shortDescription: String = "Creates a new Package.swift file with basic structure"

    // MARK: - Initializers
    public init() {}

    // MARK: - Instance Methods
    public func execute() throws {
        print("Command '\(name)' is not yet implemented.", level: .info)
    }
}

import Foundation
import SwiftCLI
import SwiftDependencyManagerKit

// MARK: - CLI
let cli = CLI(name: "sdm", version: "0.1.0", description: "A dependency manager based on Swift Package Manager (SPM) for iOS/macOS/tvOS/watchOS.")
cli.commands = [CleanCommand(), BuildCommand(), InitCommand(), InstallCommand(), UpdateCommand()]
cli.globalOptions.append(contentsOf: GlobalOptions.all)
cli.goAndExit()

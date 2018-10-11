// beak: kareman/SwiftShell @ .upToNextMajor(from: "4.0.1")
// beak: stencilproject/Stencil @ .upToNextMajor(from: "0.11.0")

import Foundation
import SwiftShell

/// Generates the LinuxMain.swift file by automatically searching the Tests path for tests.
public func generateLinuxMain() {
    run(bash: "sourcery --sources Tests --templates .sourcery/LinuxMain.stencil --output .sourcery --force-parse generated")
    run(bash: "mv .sourcery/LinuxMain.generated.swift Tests/LinuxMain.swift")
}

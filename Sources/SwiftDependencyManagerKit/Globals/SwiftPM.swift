import Foundation
import SwiftCLI

struct SwiftPM {
    static let shared = SwiftPM()

    func updateDependencies() throws {
        try run(bash: "swift package update")
    }

    func resolveDependencies() throws {
        try run(bash: "swift package resolve")
    }
}

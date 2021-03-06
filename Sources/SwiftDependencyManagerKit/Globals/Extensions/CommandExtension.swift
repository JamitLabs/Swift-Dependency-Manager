import Foundation
import SwiftCLI

extension Command {
    func measure(_ task: String, _ closure: () throws -> Void) rethrows {
        let begin = Date()
        try closure()
        printTimeSummary(task: task, begin: begin)
    }

    private func printTimeSummary(task: String, begin: Date) {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 3
        numberFormatter.decimalSeparator = "."
        numberFormatter.usesGroupingSeparator = false

        let secondsPassed = Date().timeIntervalSince(begin)
        let formattedSeconds = numberFormatter.string(from: NSNumber(value: secondsPassed))!
        print("\(task) took \(formattedSeconds) seconds in total.", level: .info)
    }
}

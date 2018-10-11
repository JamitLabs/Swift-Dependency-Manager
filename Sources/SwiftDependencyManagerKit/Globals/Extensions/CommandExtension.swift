//
//  CommandExtension.swift
//  SwiftDependencyManagerKit
//
//  Created by Cihat Gündüz on 11.10.18.
//

import Foundation
import SwiftCLI

extension Command {
    func measure(_ task: String, _ closure: () -> Void) {
        let begin = Date()
        closure()
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

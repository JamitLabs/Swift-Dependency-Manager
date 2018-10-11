// swiftlint:disable leveled_print file_types_order

import CLISpinner
import Foundation
import Rainbow

enum PrintLevel {
    case verbose
    case info
    case warning
    case error

    var color: Color {
        switch self {
        case .verbose:
            return Color.lightCyan

        case .info:
            return Color.lightBlue

        case .warning:
            return Color.yellow

        case .error:
            return Color.red
        }
    }
}

enum OutputFormatTarget {
    case human
    case xcode
}

func print(_ message: String, level: PrintLevel, file: String? = nil, line: Int? = nil) {
    switch Constants.outputFormatTarget {
    case .human:
        humanPrint(message, level: level, file: file, line: line)

    case .xcode:
        xcodePrint(message, level: level, file: file, line: line)
    }
}

private func humanPrint(_ message: String, level: PrintLevel, file: String? = nil, line: Int? = nil) {
    let location = locationInfo(file: file, line: line)
    let message = location != nil ? [location!, message].joined(separator: " ") : message

    switch level {
    case .verbose:
        if GlobalOptions.verbose.value {
            print(currentDateTime(), "🗣 ", message.lightCyan)
        }

    case .info:
        print(currentDateTime(), "ℹ️ ", message.lightBlue)

    case .warning:
        print(currentDateTime(), "⚠️ ", message.yellow)

    case .error:
        print(currentDateTime(), "❌ ", message.red)
    }
}

private func currentDateTime() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    let dateTime = dateFormatter.string(from: Date())
    return "\(dateTime):"
}

private func xcodePrint(_ message: String, level: PrintLevel, file: String? = nil, line: Int? = nil) {
    let location = locationInfo(file: file, line: line)

    switch level {
    case .verbose:
        if GlobalOptions.verbose.value {
            if let location = location {
                print(location, "verbose: sdm: ", message)
            } else {
                print("verbose: sdm: ", message)
            }
        }

    case .info:
        if let location = location {
            print(location, "info: sdm: ", message)
        } else {
            print("info: sdm: ", message)
        }

    case .warning:
        if let location = location {
            print(location, "warning: sdm: ", message)
        } else {
            print("warning: sdm: ", message)
        }

    case .error:
        if let location = location {
            print(location, "error: sdm: ", message)
        } else {
            print("error: sdm: ", message)
        }
    }
}

private func locationInfo(file: String?, line: Int?) -> String? {
    guard let file = file else { return nil }
    guard let line = line else { return "\(file): " }
    return "\(file):\(line): "
}

private let dispatchGroup = DispatchGroup()

func performWithSpinner(
    _ message: String,
    level: PrintLevel = .info,
    pattern: CLISpinner.Pattern = .dots,
    _ body: @escaping (@escaping (() -> Void) -> Void) -> Void
    ) {
    let spinner = Spinner(pattern: pattern, text: message, color: level.color)
    spinner.start()
    spinner.unhideCursor()

    dispatchGroup.enter()
    body { completion in
        spinner.stopAndClear()
        completion()
        dispatchGroup.leave()
    }

    dispatchGroup.wait()
}

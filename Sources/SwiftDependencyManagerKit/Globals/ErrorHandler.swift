import Foundation
import MungoHealer

let mungo = ErrorHandling.shared.setup()

final class ErrorHandling {
    static let shared = ErrorHandling()

    func setup() -> MungoHealer {
        return MungoHealer(errorHandler: self)
    }
}

extension ErrorHandling: ErrorHandler {
    func handle(error: Error) {
        print(error.localizedDescription, level: .error)
    }

    func handle(baseError: BaseError) {
        print(baseError.localizedDescription, level: .error)
    }

    func handle(fatalError: FatalError) {
        print(fatalError.localizedDescription, level: .error)
        exit(EXIT_FAILURE)
    }

    func handle(healableError: HealableError) {
        print("Healable error handling is not yet implemented:", level: .warning)
        handle(baseError: healableError)
    }
}

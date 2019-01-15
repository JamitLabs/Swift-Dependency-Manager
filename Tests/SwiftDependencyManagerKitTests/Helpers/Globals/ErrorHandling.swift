import XCTest
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
        XCTFail("Error thrown: \(error.localizedDescription)")
    }

    func handle(baseError: BaseError) {
        XCTFail("Base Error thrown: \(baseError.errorDescription)")
    }

    func handle(fatalError: FatalError) {
        XCTFail("Fatal Error thrown: \(fatalError.errorDescription)")
    }

    func handle(healableError: HealableError) {
        XCTFail("Healable Error thrown: \(healableError.errorDescription)")
    }
}

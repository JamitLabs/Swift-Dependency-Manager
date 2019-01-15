@testable import SwiftDependencyManagerKit
import XCTest

class CartfileTests: XCTestCase {
    func testInitWithFileContents() {
        let cartfileContents: String = """
            github "Alamofire/Alamofire" ~> 4.1
            github "ReactiveCocoa/ReactiveSwift" ~> 4.0
            github "ReactiveX/RxSwift" ~> 4.0
            github "antitypical/Result" ~> 4.0
            """

        if let cartfile = mungo.make({ try Cartfile(productName: "Moya", fileContents: cartfileContents) }) {
            XCTAssertEqual(cartfile.productName, "Moya")

            XCTAssertEqual(cartfile.dependencies.count, 4)
            XCTAssertEqual(cartfile.dependencies[0].name, "Alamofire")
            XCTAssertEqual(cartfile.dependencies[1].name, "ReactiveSwift")
            XCTAssertEqual(cartfile.dependencies[2].name, "RxSwift")
            XCTAssertEqual(cartfile.dependencies[3].name, "Result")
        }
    }

    func testToManifest() {
        let cartfileContents: String = """
            github "Alamofire/Alamofire" ~> 4.1
            github "ReactiveCocoa/ReactiveSwift" ~> 4.0
            github "ReactiveX/RxSwift" ~> 4.0
            github "antitypical/Result" ~> 4.0
            """

        if let cartfile = mungo.make({ try Cartfile(productName: "Moya", fileContents: cartfileContents) }) {
            let manifest = cartfile.toManifest()

            XCTAssertEqual(manifest.products.count, 1)
            XCTAssertEqual(manifest.products[0].name, "Moya")
            XCTAssertEqual(manifest.products[0].paths, nil)
            XCTAssertEqual(manifest.products[0].dependencies, nil)

            XCTAssertEqual(cartfile.dependencies.count, 4)
            XCTAssertEqual(cartfile.dependencies[0].name, "Alamofire")
            XCTAssertEqual(cartfile.dependencies[1].name, "ReactiveSwift")
            XCTAssertEqual(cartfile.dependencies[2].name, "RxSwift")
            XCTAssertEqual(cartfile.dependencies[3].name, "Result")

        }
    }
}

@testable import SwiftDependencyManagerKit
import XCTest

class CartfileTests: XCTestCase {
    func testMakeManifest() {
        let cartfileContents: String = """
            github "Alamofire/Alamofire" ~> 4.1
            github "ReactiveCocoa/ReactiveSwift" ~> 4.0
            github "ReactiveX/RxSwift" ~> 4.0
            github "antitypical/Result" ~> 4.0
            """

        let manifest = try! Cartfile.makeManifest(fileContents: cartfileContents, productName: "Moya")

        XCTAssertEqual(manifest.products.count, 1)
        XCTAssertEqual(manifest.products[0].name, "Moya")
        XCTAssertEqual(manifest.products[0].paths, nil)
        XCTAssertEqual(manifest.products[0].dependencies, nil)

        XCTAssertEqual(manifest.dependencies.count, 4)
        XCTAssertEqual(manifest.dependencies[0].name, "Alamofire")
        XCTAssertEqual(manifest.dependencies[1].name, "ReactiveSwift")
        XCTAssertEqual(manifest.dependencies[2].name, "RxSwift")
        XCTAssertEqual(manifest.dependencies[3].name, "Result")
    }
}

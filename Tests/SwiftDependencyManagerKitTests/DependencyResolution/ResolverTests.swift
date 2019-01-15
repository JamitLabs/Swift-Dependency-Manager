@testable import SwiftDependencyManagerKit
import HandySwift
import PromiseKit
import XCTest

class ResolverTests: XCTestCase {
    func testResolveDependenciesWithSDMCompatibleDependencies() {
//        let manifestContents: String = """
//            [[dependencies]]
//            name = "HandySwift"
//            gitPath = "https://github.com/Flinesoft/HandySwift.git"
//            version = "branch:work/sdm"
//            """
//        let manifest = try! Manifest.make(fileContents: manifestContents)
//        let expectation = self.expectation(description: "Wait for dependency resolution.")
//
//        firstly {
//            Resolver().resolveDependencies(manifest: manifest, product: Product(name: "App"))
//        }.done { dependencies in
//            XCTAssertEqual(dependencies.count, 1)
//            expectation.fulfill()
//        }.catch { error in
//            XCTFail(error.localizedDescription)
//            expectation.fulfill()
//        }
//
//        waitForExpectations(timeout: .seconds(30))
    }

    func testResolveDependenciesWithCarthageCompatibleDependencies() {
//        let manifestContents: String = """
//            [[dependencies]]
//            name = "CSVImporter"
//            gitPath = "https://github.com/Flinesoft/CSVImporter.git"
//            version = "any"
//
//            [[dependencies]]
//            name = "Moya"
//            gitPath = "https://github.com/Moya/Moya.git"
//            version = "upToNextMajor:12.0"
//            """
//        let manifest = try! Manifest.make(fileContents: manifestContents)
//        let expectation = self.expectation(description: "Wait for dependency resolution.")
//
//        firstly {
//            Resolver().resolveDependencies(manifest: manifest, product: Product(name: "App"))
//        }.done { dependencies in
//            let dependencyNames = Set(dependencies.map { $0.name })
//            XCTAssertEqual(dependencyNames, ["CSVImporter", "Moya", "HandySwift", "Alamofire", "ReactiveSwift", "RxSwift", "Result"])
//            expectation.fulfill()
//        }.catch { error in
//            XCTFail(error.localizedDescription)
//            expectation.fulfill()
//        }
//
//        waitForExpectations(timeout: .seconds(300))
    }
}

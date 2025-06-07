import XCTest
@testable import Data

final class DataTests: XCTestCase {
    func testDataModuleVersion() {
        XCTAssertEqual(DataModule.version, "1.0.0")
    }
}
import XCTest
@testable import Domain

final class DomainTests: XCTestCase {
    func testDomainModuleVersion() {
        XCTAssertEqual(DomainModule.version, "1.0.0")
    }
}
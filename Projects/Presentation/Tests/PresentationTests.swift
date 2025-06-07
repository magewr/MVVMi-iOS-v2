import XCTest
@testable import Presentation

final class PresentationTests: XCTestCase {
    func testPresentationModuleVersion() {
        XCTAssertEqual(PresentationModule.version, "1.0.0")
    }
}
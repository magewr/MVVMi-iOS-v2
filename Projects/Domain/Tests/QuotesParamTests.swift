import XCTest
@testable import Domain

final class QuotesParamTests: XCTestCase {
    
    func testValidQuotesParam() throws {
        // Given & When
        let param = try QuotesParam(language: "en", limit: 1)
        
        // Then
        XCTAssertEqual(param.language, "en")
        XCTAssertEqual(param.limit, 1)
    }
    
    func testDefaultValues() throws {
        // Given & When
        let param = try QuotesParam()
        
        // Then
        XCTAssertEqual(param.language, "en")
        XCTAssertEqual(param.limit, 1)
    }
    
    func testLanguageNormalization() throws {
        // Given & When
        let param = try QuotesParam(language: "  EN  ", limit: 5)
        
        // Then
        XCTAssertEqual(param.language, "en")
        XCTAssertEqual(param.limit, 5)
    }
    
    func testInvalidLanguage_Empty() {
        // Given & When & Then
        XCTAssertThrowsError(try QuotesParam(language: "", limit: 1)) { error in
            XCTAssertTrue(error is QuotesParamError)
            XCTAssertEqual(error as? QuotesParamError, .invalidLanguage)
        }
    }
    
    func testInvalidLanguage_Whitespace() {
        // Given & When & Then
        XCTAssertThrowsError(try QuotesParam(language: "   ", limit: 1)) { error in
            XCTAssertTrue(error is QuotesParamError)
            XCTAssertEqual(error as? QuotesParamError, .invalidLanguage)
        }
    }
    
    func testInvalidLimit_Zero() {
        // Given & When & Then
        XCTAssertThrowsError(try QuotesParam(language: "en", limit: 0)) { error in
            XCTAssertTrue(error is QuotesParamError)
            XCTAssertEqual(error as? QuotesParamError, .invalidLimit)
        }
    }
    
    func testInvalidLimit_Negative() {
        // Given & When & Then
        XCTAssertThrowsError(try QuotesParam(language: "en", limit: -1)) { error in
            XCTAssertTrue(error is QuotesParamError)
            XCTAssertEqual(error as? QuotesParamError, .invalidLimit)
        }
    }
    
    func testInvalidLimit_TooLarge() {
        // Given & When & Then
        XCTAssertThrowsError(try QuotesParam(language: "en", limit: 101)) { error in
            XCTAssertTrue(error is QuotesParamError)
            XCTAssertEqual(error as? QuotesParamError, .invalidLimit)
        }
    }
    
    func testValidLimit_MaxValue() throws {
        // Given & When
        let param = try QuotesParam(language: "en", limit: 100)
        
        // Then
        XCTAssertEqual(param.limit, 100)
    }
    
    func testErrorDescriptions() {
        XCTAssertEqual(QuotesParamError.invalidLanguage.errorDescription, "언어 코드가 유효하지 않습니다.")
        XCTAssertEqual(QuotesParamError.invalidLimit.errorDescription, "요청 개수는 1-100 사이여야 합니다.")
    }
} 
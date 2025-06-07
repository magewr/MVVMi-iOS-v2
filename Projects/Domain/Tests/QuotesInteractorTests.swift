import XCTest
@testable import Domain

final class QuotesInteractorTests: XCTestCase {
    private var interactor: QuotesInteractor!
    private var mockRepository: MockQuoteRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockQuoteRepository()
        interactor = QuotesInteractor(repository: mockRepository)
    }
    
    override func tearDown() {
        interactor = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testGetRandomQuote_Success() async throws {
        // Given
        let expectedQuote = Quote(id: "test123", content: "Test quote", author: "Test Author")
        mockRepository.mockQuote = expectedQuote
        let param = try QuotesParam(language: "en", limit: 1)
        
        // When
        let result = try await interactor.getRandomQuote(param: param)
        
        // Then
        XCTAssertEqual(result.id, expectedQuote.id)
        XCTAssertEqual(result.content, expectedQuote.content)
        XCTAssertEqual(result.author, expectedQuote.author)
        XCTAssertTrue(mockRepository.getRandomQuoteCalled)
        XCTAssertEqual(mockRepository.lastParam?.language, param.language)
        XCTAssertEqual(mockRepository.lastParam?.limit, param.limit)
    }
    
    func testGetRandomQuote_RepositoryError() async {
        // Given
        mockRepository.shouldThrowError = true
        let param = try! QuotesParam(language: "en", limit: 1)
        
        // When & Then
        do {
            _ = try await interactor.getRandomQuote(param: param)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(mockRepository.getRandomQuoteCalled)
            // Error가 제대로 전파되는지 확인
        }
    }
    
    func testGetQuoteList_Success() async throws {
        // Given
        let expectedQuotes = [
            Quote(id: "test1", content: "First quote", author: "First Author"),
            Quote(id: "test2", content: "Second quote", author: "Second Author")
        ]
        mockRepository.mockQuoteList = expectedQuotes
        let param = try QuotesParam(language: "en", limit: 2)
        
        // When
        let result = try await interactor.getQuoteList(param: param)
        
        // Then
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].id, expectedQuotes[0].id)
        XCTAssertEqual(result[0].content, expectedQuotes[0].content)
        XCTAssertEqual(result[0].author, expectedQuotes[0].author)
        XCTAssertEqual(result[1].id, expectedQuotes[1].id)
        XCTAssertEqual(result[1].content, expectedQuotes[1].content)
        XCTAssertEqual(result[1].author, expectedQuotes[1].author)
        XCTAssertTrue(mockRepository.getQuoteListCalled)
        XCTAssertEqual(mockRepository.lastParam?.language, param.language)
        XCTAssertEqual(mockRepository.lastParam?.limit, param.limit)
    }
    
    func testGetQuoteList_EmptyArray() async throws {
        // Given
        mockRepository.mockQuoteList = []
        let param = try QuotesParam(language: "en", limit: 1)
        
        // When
        let result = try await interactor.getQuoteList(param: param)
        
        // Then
        XCTAssertEqual(result.count, 0)
        XCTAssertTrue(mockRepository.getQuoteListCalled)
    }
    
    func testGetQuoteList_RepositoryError() async {
        // Given
        mockRepository.shouldThrowError = true
        let param = try! QuotesParam(language: "en", limit: 1)
        
        // When & Then
        do {
            _ = try await interactor.getQuoteList(param: param)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(mockRepository.getQuoteListCalled)
            // Error가 제대로 전파되는지 확인
        }
    }
}

// MARK: - Mock Repository
private class MockQuoteRepository: QuoteRepositoryProtocol {
    var mockQuote: Quote?
    var mockQuoteList: [Quote]?
    var shouldThrowError = false
    var getRandomQuoteCalled = false
    var getQuoteListCalled = false
    var lastParam: QuotesParam?
    
    func getRandomQuote(param: QuotesParam) async throws -> Quote {
        getRandomQuoteCalled = true
        lastParam = param
        
        if shouldThrowError {
            throw TestError.mockError
        }
        
        guard let quote = mockQuote else {
            throw TestError.noMockData
        }
        
        return quote
    }
    
    func getQuoteList(param: QuotesParam) async throws -> [Quote] {
        getQuoteListCalled = true
        lastParam = param
        
        if shouldThrowError {
            throw TestError.mockError
        }
        
        guard let quoteList = mockQuoteList else {
            throw TestError.noMockData
        }
        
        return quoteList
    }
}

private enum TestError: Error {
    case mockError
    case noMockData
} 
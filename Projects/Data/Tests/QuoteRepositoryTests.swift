import XCTest
import Moya
@testable import Data
@testable import Domain

final class QuoteRepositoryTests: XCTestCase {
    private var repository: QuoteRepository!
    private var mockProvider: MoyaProvider<QuoteAPI>!
    
    override func setUp() {
        super.setUp()
        
        // Mock 설정
        let mockEndpointClosure = { (target: QuoteAPI) -> Endpoint in
            return Endpoint(
                url: URL(target: target).absoluteString,
                sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers
            )
        }
        
        mockProvider = MoyaProvider<QuoteAPI>(
            endpointClosure: mockEndpointClosure,
            stubClosure: MoyaProvider.immediatelyStub
        )
        
        repository = QuoteRepository(provider: mockProvider)
    }
    
    override func tearDown() {
        repository = nil
        mockProvider = nil
        super.tearDown()
    }
    
    func testGetRandomQuote_Success() async throws {
        // Given
        let param = try QuotesParam(language: "en", limit: 1)
        
        // When
        let quote = try await repository.getRandomQuote(param: param)
        
        // Then
        XCTAssertEqual(quote.id, "sample123")
        XCTAssertEqual(quote.content, "Sample quote content")
        XCTAssertEqual(quote.author, "Sample Author")
    }
    
    func testGetRandomQuote_NetworkError() async {
        // Given
        let errorProvider = MoyaProvider<QuoteAPI>(
            endpointClosure: { target in
                Endpoint(
                    url: URL(target: target).absoluteString,
                    sampleResponseClosure: { .networkResponse(500, Data()) },
                    method: target.method,
                    task: target.task,
                    httpHeaderFields: target.headers
                )
            },
            stubClosure: MoyaProvider.immediatelyStub
        )
        
        repository = QuoteRepository(provider: errorProvider)
        let param = try! QuotesParam(language: "en", limit: 1)
        
        // When & Then
        do {
            _ = try await repository.getRandomQuote(param: param)
            XCTFail("Expected error to be thrown")
        } catch let error as BaseRepositoryError {
            switch error {
            case .networkError(let statusCode):
                XCTAssertEqual(statusCode, 500)
            default:
                XCTFail("Expected networkError, got \(error)")
            }
        } catch {
            XCTFail("Expected BaseRepositoryError, got \(error)")
        }
    }
    
    func testGetRandomQuote_NoData() async {
        // Given
        let emptyDataProvider = MoyaProvider<QuoteAPI>(
            endpointClosure: { target in
                Endpoint(
                    url: URL(target: target).absoluteString,
                    sampleResponseClosure: { .networkResponse(200, "[]".data(using: .utf8)!) },
                    method: target.method,
                    task: target.task,
                    httpHeaderFields: target.headers
                )
            },
            stubClosure: MoyaProvider.immediatelyStub
        )
        
        repository = QuoteRepository(provider: emptyDataProvider)
        let param = try! QuotesParam(language: "en", limit: 1)
        
        // When & Then
        do {
            _ = try await repository.getRandomQuote(param: param)
            XCTFail("Expected error to be thrown")
        } catch let error as BaseRepositoryError {
            switch error {
            case .noData:
                break // Expected
            default:
                XCTFail("Expected noData error, got \(error)")
            }
        } catch {
            XCTFail("Expected BaseRepositoryError, got \(error)")
        }
    }
    
    // MARK: - getQuoteList Tests
    
    func testGetQuoteList_Success() async throws {
        // Given
        let multiQuoteProvider = MoyaProvider<QuoteAPI>(
            endpointClosure: { target in
                let multiQuoteData = """
                [
                    {
                        "_id": "quote1",
                        "en": "First quote content",
                        "author": "First Author"
                    },
                    {
                        "_id": "quote2",
                        "en": "Second quote content",
                        "author": "Second Author"
                    }
                ]
                """
                return Endpoint(
                    url: URL(target: target).absoluteString,
                    sampleResponseClosure: { .networkResponse(200, multiQuoteData.data(using: .utf8)!) },
                    method: target.method,
                    task: target.task,
                    httpHeaderFields: target.headers
                )
            },
            stubClosure: MoyaProvider.immediatelyStub
        )
        
        repository = QuoteRepository(provider: multiQuoteProvider)
        let param = try QuotesParam(language: "en", limit: 2)
        
        // When
        let quotes = try await repository.getQuoteList(param: param)
        
        // Then
        XCTAssertEqual(quotes.count, 2)
        XCTAssertEqual(quotes[0].id, "quote1")
        XCTAssertEqual(quotes[0].content, "First quote content")
        XCTAssertEqual(quotes[0].author, "First Author")
        XCTAssertEqual(quotes[1].id, "quote2")
        XCTAssertEqual(quotes[1].content, "Second quote content")
        XCTAssertEqual(quotes[1].author, "Second Author")
    }
    
    func testGetQuoteList_EmptyArray() async throws {
        // Given
        let emptyDataProvider = MoyaProvider<QuoteAPI>(
            endpointClosure: { target in
                Endpoint(
                    url: URL(target: target).absoluteString,
                    sampleResponseClosure: { .networkResponse(200, "[]".data(using: .utf8)!) },
                    method: target.method,
                    task: target.task,
                    httpHeaderFields: target.headers
                )
            },
            stubClosure: MoyaProvider.immediatelyStub
        )
        
        repository = QuoteRepository(provider: emptyDataProvider)
        let param = try QuotesParam(language: "en", limit: 1)
        
        // When
        let quotes = try await repository.getQuoteList(param: param)
        
        // Then
        XCTAssertEqual(quotes.count, 0)
    }
    
    func testGetQuoteList_NetworkError() async {
        // Given
        let errorProvider = MoyaProvider<QuoteAPI>(
            endpointClosure: { target in
                Endpoint(
                    url: URL(target: target).absoluteString,
                    sampleResponseClosure: { .networkResponse(500, Data()) },
                    method: target.method,
                    task: target.task,
                    httpHeaderFields: target.headers
                )
            },
            stubClosure: MoyaProvider.immediatelyStub
        )
        
        repository = QuoteRepository(provider: errorProvider)
        let param = try! QuotesParam(language: "en", limit: 1)
        
        // When & Then
        do {
            _ = try await repository.getQuoteList(param: param)
            XCTFail("Expected error to be thrown")
        } catch let error as BaseRepositoryError {
            switch error {
            case .networkError(let statusCode):
                XCTAssertEqual(statusCode, 500)
            default:
                XCTFail("Expected networkError, got \(error)")
            }
        } catch {
            XCTFail("Expected BaseRepositoryError, got \(error)")
        }
    }
} 
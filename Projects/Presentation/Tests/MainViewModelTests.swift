import XCTest
import Domain
@testable import Presentation

@MainActor
final class MainViewModelTests: XCTestCase {
    private var viewModel: MainViewModel!
    private var mockInteractor: MockQuotesInteractor!
    
    override func setUp() {
        super.setUp()
        mockInteractor = MockQuotesInteractor()
        let dependency = MainViewModel.Dependency(quotesInteractor: mockInteractor)
        viewModel = MainViewModel(dependency: dependency)
    }
    
    override func tearDown() {
        viewModel = nil
        mockInteractor = nil
        super.tearDown()
    }
    
    func testSendFetchRandomQuoteAction_Success() async {
        // Given
        let expectedQuote = Quote(id: "test123", content: "Test content", author: "Test Author")
        mockInteractor.mockQuote = expectedQuote
        
        // When
        viewModel.send(.새로운명언_가져오기)
        
        // 비동기 작업 완료 대기
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1초
        
        // Then
        XCTAssertEqual(viewModel.quote?.id, expectedQuote.id)
        XCTAssertEqual(viewModel.quote?.content, expectedQuote.content)
        XCTAssertEqual(viewModel.quote?.author, expectedQuote.author)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertTrue(mockInteractor.getRandomQuoteCalled)
    }
    
    func testSendFetchRandomQuoteAction_Error() async {
        // Given
        mockInteractor.shouldThrowError = true
        
        // When
        viewModel.send(.새로운명언_가져오기)
        
        // 비동기 작업 완료 대기
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1초
        
        // Then
        XCTAssertNil(viewModel.quote)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(mockInteractor.getRandomQuoteCalled)
    }
    
    func testInitialState() {
        // Then
        XCTAssertNil(viewModel.quote)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testLoadingStateWithAction() async {
        // Given
        mockInteractor.shouldDelay = true
        
        // When
        viewModel.send(.새로운명언_가져오기)
        
        // Task가 시작될 때까지 잠시 대기
        try? await Task.sleep(nanoseconds: 10_000_000) // 0.01초
        
        // 로딩 상태 확인
        XCTAssertTrue(viewModel.isLoading)
        
        // 작업 완료 대기
        try? await Task.sleep(nanoseconds: 200_000_000) // 0.2초
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testActionHandling_MultipleActions() async {
        // Given
        let firstQuote = Quote(id: "test1", content: "First quote", author: "Author 1")
        let secondQuote = Quote(id: "test2", content: "Second quote", author: "Author 2")
        
        // When - 첫 번째 액션
        mockInteractor.mockQuote = firstQuote
        viewModel.send(.새로운명언_가져오기)
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then - 첫 번째 결과 확인
        XCTAssertEqual(viewModel.quote?.id, firstQuote.id)
        
        // When - 두 번째 액션
        mockInteractor.mockQuote = secondQuote
        mockInteractor.getRandomQuoteCalled = false // 리셋
        viewModel.send(.새로운명언_가져오기)
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then - 두 번째 결과 확인
        XCTAssertEqual(viewModel.quote?.id, secondQuote.id)
        XCTAssertTrue(mockInteractor.getRandomQuoteCalled)
    }
}

// MARK: - Mock Interactor
private class MockQuotesInteractor: QuotesInteractorProtocol {
    var mockQuote: Quote?
    var mockQuoteList: [Quote]?
    var shouldThrowError = false
    var shouldDelay = false
    var getRandomQuoteCalled = false
    var getQuoteListCalled = false
    var lastParam: QuotesParam?
    
    func getRandomQuote(param: QuotesParam) async throws -> Quote {
        getRandomQuoteCalled = true
        lastParam = param
        
        if shouldDelay {
            try await Task.sleep(nanoseconds: 100_000_000) // 0.1초 지연
        }
        
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
        
        if shouldDelay {
            try await Task.sleep(nanoseconds: 100_000_000) // 0.1초 지연
        }
        
        if shouldThrowError {
            throw TestError.mockError
        }
        
        guard let quoteList = mockQuoteList else {
            throw TestError.noMockData
        }
        
        return quoteList
    }
}

private enum TestError: Error, LocalizedError {
    case mockError
    case noMockData
    
    var errorDescription: String? {
        switch self {
        case .mockError:
            return "Mock error occurred"
        case .noMockData:
            return "No mock data available"
        }
    }
} 

import Foundation

public protocol QuotesInteractorProtocol: BaseInteractor {
    func getRandomQuote(param: QuotesParam) async throws -> Quote
    func getQuoteList(param: QuotesParam) async throws -> [Quote]
}

public final class QuotesInteractor: QuotesInteractorProtocol {
    private let repository: QuoteRepositoryProtocol
    
    public init(repository: QuoteRepositoryProtocol) {
        self.repository = repository
    }
    
    public func getRandomQuote(param: QuotesParam) async throws -> Quote {
        return try await repository.getRandomQuote(param: param)
    }
    
    public func getQuoteList(param: QuotesParam) async throws -> [Quote] {
        return try await repository.getQuoteList(param: param)
    }
}
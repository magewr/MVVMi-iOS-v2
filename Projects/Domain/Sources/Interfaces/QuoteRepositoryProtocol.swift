import Foundation

public protocol QuoteRepositoryProtocol {
    func getRandomQuote(param: QuotesParam) async throws -> Quote
    func getQuoteList(param: QuotesParam) async throws -> [Quote]
}
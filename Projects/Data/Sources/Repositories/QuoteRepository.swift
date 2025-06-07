import Foundation
import Moya
import Domain

public final class QuoteRepository: BaseRepository, QuoteRepositoryProtocol {
    private let provider: MoyaProvider<QuoteAPI>
    
    public init(provider: MoyaProvider<QuoteAPI> = MoyaProvider<QuoteAPI>()) {
        self.provider = provider
        super.init()
    }
    
    public func getRandomQuote(param: QuotesParam) async throws -> Quote {
        return try await requestRandomElement(
            provider: provider,
            target: .getRandomQuotes(param: param),
            responseType: [Quote].self
        )
    }
    
    public func getQuoteList(param: QuotesParam) async throws -> [Quote] {
        return try await request(
            provider: provider,
            target: .getQuoteList(param: param),
            responseType: [Quote].self
        )
    }
}
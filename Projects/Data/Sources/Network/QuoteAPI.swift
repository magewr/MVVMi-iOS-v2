import Foundation
import Moya
import Domain

public enum QuoteAPI {
    case getRandomQuotes(param: QuotesParam)
    case getQuoteList(param: QuotesParam)
}

extension QuoteAPI: TargetType {
    public var baseURL: URL {
        return URL(string: "https://philosophy-quotes-api.glitch.me")!
    }
    
    public var path: String {
        switch self {
        case .getRandomQuotes, .getQuoteList:
            return "/quotes"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getRandomQuotes, .getQuoteList:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .getRandomQuotes(let param), .getQuoteList(let param):
            var parameters: [String: Any] = [:]
            if param.limit > 0 {
                parameters["limit"] = param.limit
            }
            if !param.language.isEmpty {
                parameters["language"] = param.language
            }
            return parameters.isEmpty ? .requestPlain : .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    public var sampleData: Data {
        switch self {
        case .getRandomQuotes, .getQuoteList:
            let sampleQuote = """
            [{
                "_id": "sample123",
                "en": "Sample quote content",
                "author": "Sample Author"
            }]
            """
            return sampleQuote.data(using: .utf8) ?? Data()
        }
    }
} 
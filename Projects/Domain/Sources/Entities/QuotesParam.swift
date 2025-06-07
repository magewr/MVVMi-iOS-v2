import Foundation

public struct QuotesParam {
    public let language: String
    public let limit: Int
    
    public init(language: String = "en", limit: Int = 1) throws {
        // 언어 코드 검증
        guard !language.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw QuotesParamError.invalidLanguage
        }
        
        // limit 범위 검증
        guard limit > 0 && limit <= 100 else {
            throw QuotesParamError.invalidLimit
        }
        
        self.language = language.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        self.limit = limit
    }
}

public enum QuotesParamError: Error, LocalizedError {
    case invalidLanguage
    case invalidLimit
    
    public var errorDescription: String? {
        switch self {
        case .invalidLanguage:
            return "언어 코드가 유효하지 않습니다."
        case .invalidLimit:
            return "요청 개수는 1-100 사이여야 합니다."
        }
    }
}
import Foundation
import Moya

open class BaseRepository {
    
    /// 공통 API 요청 처리 메소드
    func request<T: Codable, Target: TargetType>(
        provider: MoyaProvider<Target>,
        target: Target,
        responseType: T.Type
    ) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        // 응답 상태 코드 확인
                        guard 200...299 ~= response.statusCode else {
                            continuation.resume(throwing: BaseRepositoryError.networkError(statusCode: response.statusCode))
                            return
                        }
                        
                        let decodedData = try response.map(responseType)
                        continuation.resume(returning: decodedData)
                        
                    } catch {
                        continuation.resume(throwing: BaseRepositoryError.decodingError(error))
                    }
                    
                case .failure(let error):
                    continuation.resume(throwing: BaseRepositoryError.moyaError(error))
                }
            }
        }
    }
    
    /// 배열 타입 응답을 처리하고 랜덤 요소를 반환하는 메소드
    func requestRandomElement<T: Codable, Target: TargetType>(
        provider: MoyaProvider<Target>,
        target: Target,
        responseType: [T].Type
    ) async throws -> T {
        let array: [T] = try await request(provider: provider, target: target, responseType: responseType)
        
        guard let randomElement = array.randomElement() else {
            throw BaseRepositoryError.noData
        }
        
        return randomElement
    }
}

// MARK: - BaseRepositoryError
public enum BaseRepositoryError: Error, LocalizedError {
    case networkError(statusCode: Int)
    case noData
    case decodingError(Error)
    case moyaError(MoyaError)
    
    public var errorDescription: String? {
        switch self {
        case .networkError(let statusCode):
            return "네트워크 오류가 발생했습니다. (상태 코드: \(statusCode))"
        case .noData:
            return "데이터가 없습니다."
        case .decodingError(let error):
            return "데이터 디코딩 오류입니다: \(error.localizedDescription)"
        case .moyaError(let error):
            switch error {
            case .underlying(let nsError, _):
                if let urlError = nsError as? URLError {
                    switch urlError.code {
                    case .timedOut:
                        return "요청 시간이 초과되었습니다."
                    case .notConnectedToInternet:
                        return "인터넷 연결을 확인해주세요."
                    case .networkConnectionLost:
                        return "네트워크 연결이 끊어졌습니다."
                    default:
                        return "네트워크 오류가 발생했습니다."
                    }
                }
                return "알 수 없는 오류가 발생했습니다."
            case .statusCode(let response):
                return "서버 오류가 발생했습니다. (상태 코드: \(response.statusCode))"
            default:
                return "요청 처리 중 오류가 발생했습니다."
            }
        }
    }
} 

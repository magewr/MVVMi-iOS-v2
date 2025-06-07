import Foundation
import Domain

public struct DataDependencies: DependencyRegistrable {
    public static func registerDependencies(container: DIContainer) {
        container.register(QuoteRepositoryProtocol.self) {
            QuoteRepository()
        }
    }
} 
import Foundation

public struct DomainDependencies: DependencyRegistrable {
    public static func registerDependencies(container: DIContainer) {
        container.register(QuotesInteractorProtocol.self) {
            let repository = container.resolve(QuoteRepositoryProtocol.self)
            return QuotesInteractor(repository: repository)
        }
    }
} 
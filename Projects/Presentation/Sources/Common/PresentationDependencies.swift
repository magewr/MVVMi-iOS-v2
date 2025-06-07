import Foundation
import Domain

public struct PresentationDependencies: DependencyRegistrable {
    public static func registerDependencies(container: DIContainer) {
        container.register(MainViewModel.self) {
            let quotesInteractor = container.resolve(QuotesInteractorProtocol.self)
            let dependency = MainViewModel.Dependency(quotesInteractor: quotesInteractor)
            return MainViewModel(dependency: dependency)
        }
    }
} 
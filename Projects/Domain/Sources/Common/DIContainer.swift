import Foundation

public protocol DIContainer {
    func resolve<T>(_ type: T.Type) -> T
    func register<T>(_ type: T.Type, factory: @escaping () -> T)
}

public final class DefaultDIContainer: DIContainer {
    public static let shared = DefaultDIContainer()
    
    private var factories: [String: () -> Any] = [:]
    
    private init() {}
    
    public func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        let key = String(describing: type)
        factories[key] = factory
    }
    
    public func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        guard let factory = factories[key] else {
            fatalError("Dependency not registered: \(type)")
        }
        return factory() as! T
    }
}

// MARK: - Dependency Registration Protocol
public protocol DependencyRegistrable {
    static func registerDependencies(container: DIContainer)
} 
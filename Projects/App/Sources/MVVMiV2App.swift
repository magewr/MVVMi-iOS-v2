import SwiftUI
import Domain
import Data
import Presentation

@main
struct MVVMiV2App: App {
    
    init() {
        setupDependencies()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    private func setupDependencies() {
        let container = DefaultDIContainer.shared
        
        // 의존성 등록 순서 중요: Data -> Domain -> Presentation
        DataDependencies.registerDependencies(container: container)
        DomainDependencies.registerDependencies(container: container)
        PresentationDependencies.registerDependencies(container: container)
    }
}
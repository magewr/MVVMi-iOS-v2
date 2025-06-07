import Foundation
import SwiftUI
import Domain

public final class MainViewModel: BaseViewModel<MainViewModel.Action> {
    
    public enum Action {
        case 새로운명언_가져오기
    }
    
    public struct Dependency {
        public let quotesInteractor: QuotesInteractorProtocol
        
        public init(quotesInteractor: QuotesInteractorProtocol) {
            self.quotesInteractor = quotesInteractor
        }
    }
    
    // UI 바인딩을 위한 @Published 프로퍼티들 - 자동으로 메인 스레드에서 업데이트됨
    @Published public var quote: Quote?
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    
    private let dependency: Dependency
    
    public init(dependency: Dependency) {
        self.dependency = dependency
        super.init()
    }
    
    // MARK: - Override BaseViewModel
    /// 베이스 클래스의 추상 메서드를 구현 - 메인 스레드에서 실행되는 액션 처리 로직
    @MainActor
    public override func handle(_ action: Action) async {
        switch action {
        case .새로운명언_가져오기:
            await fetchRandomQuote()
        }
    }
    
    // MARK: - Private Implementation
    /// 랜덤 명언을 가져오는 비즈니스 로직 - UI 업데이트를 위해 메인 스레드에서 실행
    @MainActor
    private func fetchRandomQuote() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let param = try QuotesParam(language: "en", limit: 1)
            let fetchedQuote = try await dependency.quotesInteractor.getRandomQuote(param: param)
            quote = fetchedQuote
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

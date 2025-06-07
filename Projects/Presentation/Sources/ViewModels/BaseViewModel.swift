import Foundation
import SwiftUI

/// 모든 ViewModel에서 공통적으로 사용할 베이스 클래스
/// Action enum을 제네릭으로 받아서 각 ViewModel마다 다른 Action을 처리할 수 있도록 함
open class BaseViewModel<Action>: ObservableObject {
    
    public init() {}
    
    // MARK: - Public Interface
    /// 어떤 스레드에서든 안전하게 호출 가능한 액션 전송 메서드
    /// 모든 ViewModel에서 공통적으로 사용할 수 있는 패턴
    public func send(_ action: Action) {
        Task { @MainActor in
            await handle(action)
        }
    }
    
    // MARK: - Abstract Method
    /// 서브클래스에서 반드시 구현해야 하는 액션 처리 메서드
    /// 메인 스레드에서 실행되는 액션 처리 로직
    @MainActor
    open func handle(_ action: Action) async {
        fatalError("Subclasses must implement handle(_:) method")
    }
} 

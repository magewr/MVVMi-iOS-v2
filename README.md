# MVVMi-v2 iOS 프로젝트

## 📱 프로젝트 개요

클린 아키텍처 기반의 MVVM 패턴을 적용한 현대적인 iOS 앱입니다. 

MVVMi iOS v1에서 Swift Concurrency와 SwiftUI, Tuist 를 적용하며 개선한 버전입니다.

### 🔄 주요 기술 스택

| 구분 | 기술 | 버전 |
|------|------|------|
| **UI Framework** | SwiftUI | iOS 15.0+ |
| **비동기 처리** | Swift Concurrency | async/await |
| **프로젝트 관리** | Tuist | 4.51.2 |
| **네트워크** | Moya | Latest |
| **아키텍처** | Clean Architecture + MVVM | - |
| **의존성 주입** | Custom DI Container | - |

## 🏗️ 아키텍처

### Clean Architecture 레이어 구조
```
┌─────────────────────────────────────────┐
│              Presentation               │ ← SwiftUI Views + ViewModels
│  ┌─────────────┐    ┌─────────────────┐ │
│  │    View     │◄───┤    ViewModel    │ │
│  │             │    │                 │ │
│  └─────────────┘    └─────────────────┘ │
└─────────────────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────┐
│                Domain                   │ ← Business Logic
│  ┌─────────────┐    ┌─────────────────┐ │
│  │ Interactor  │◄───┤   Repository    │ │
│  │             │    │   Protocol      │ │
│  └─────────────┘    └─────────────────┘ │
└─────────────────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────┐
│                 Data                    │ ← Data Sources
│  ┌─────────────┐    ┌─────────────────┐ │
│  │ Repository  │◄───┤   Network API   │ │
│  │ Implement   │    │      (Moya)     │ │
│  └─────────────┘    └─────────────────┘ │
└─────────────────────────────────────────┘
```

### 의존성 방향
- **Presentation** → **Domain** → **Data**
- 각 레이어는 하위 레이어의 추상화(Protocol)에만 의존
- 의존성 역전 원칙(DIP) 적용

## 📦 프로젝트 구조

```
MVVMi-v2/
├── Tuist.swift                     # Tuist 설정
├── Workspace.swift                 # Workspace 정의
├── Projects/
│   ├── App/                        # 메인 앱 모듈
│   │   ├── Project.swift
│   │   ├── Sources/
│   │   │   ├── MVVMiV2App.swift   # App 진입점
│   │   │   └── ContentView.swift   # 루트 View
│   │   └── Tests/
│   ├── Presentation/               # UI 레이어
│   │   ├── Project.swift
│   │   ├── Sources/
│   │   │   ├── Views/
│   │   │   │   └── MainView.swift
│   │   │   ├── ViewModels/
│   │   │   │   ├── BaseViewModel.swift
│   │   │   │   └── MainViewModel.swift
│   │   │   └── Common/
│   │   │       └── PresentationDependencies.swift
│   │   └── Tests/
│   ├── Domain/                     # 비즈니스 로직 레이어
│   │   ├── Project.swift
│   │   ├── Sources/
│   │   │   ├── Models/
│   │   │   │   ├── Quote.swift
│   │   │   │   └── QuoteError.swift
│   │   │   ├── Parameters/
│   │   │   │   └── QuotesParam.swift
│   │   │   ├── Repositories/
│   │   │   │   └── QuoteRepositoryProtocol.swift
│   │   │   ├── Interactors/
│   │   │   │   ├── Base/
│   │   │   │   │   └── BaseInteractor.swift
│   │   │   │   ├── QuotesInteractor.swift
│   │   │   │   └── QuotesInteractorProtocol.swift
│   │   │   └── Common/
│   │   │       ├── DIContainer.swift
│   │   │       └── DomainDependencies.swift
│   │   └── Tests/
│   └── Data/                       # 데이터 레이어
│       ├── Project.swift
│       ├── Sources/
│       │   ├── Network/
│       │   │   └── QuoteAPI.swift
│       │   ├── Repositories/
│       │   │   └── QuoteRepository.swift
│       │   └── Common/
│       │       └── DataDependencies.swift
│       └── Tests/
└── Derived/                        # Tuist 생성 파일들
```

## 🛠️ 의존성 주입 패턴

### DI Container 구조
```swift
// 1. 각 레이어별 Dependencies 등록
DataDependencies.registerDependencies(container: container)
DomainDependencies.registerDependencies(container: container)  
PresentationDependencies.registerDependencies(container: container)

// 2. 런타임에 의존성 해결
let viewModel = DefaultDIContainer.shared.resolve(MainViewModel.self)
```

### ViewModel 의존성 패턴
```swift
public final class MainViewModel: BaseViewModel<MainViewModel.Action> {
    public struct Dependency {
        public let quotesInteractor: QuotesInteractorProtocol
    }
    
    private let dependency: Dependency
    
    public init(dependency: Dependency) {
        self.dependency = dependency
        super.init()
    }
}
```

## 🚀 빌드 및 실행

### 시스템 요구사항
- **macOS**: 12.0 이상
- **Xcode**: 15.0 이상
- **iOS**: 15.0 이상
- **Swift**: 5.9 이상
- **Tuist**: 4.51.2 이상

### 1. Tuist 설치
```bash
# Homebrew를 통한 설치
brew install tuist

# 버전 확인
tuist version
```

### 2. 프로젝트 클론
```bash
git clone [repository-url]
cd MVVMi-v2
```

### 3. 의존성 설치 및 프로젝트 생성
```bash
# 외부 의존성 설치 (필요한 경우)
tuist install

# Xcode 프로젝트 및 워크스페이스 생성
tuist generate
```

### 4. Xcode에서 열기
```bash
# 워크스페이스 열기
open MVVMi-v2.xcworkspace

# 또는 직접 실행
tuist generate --open
```

### 5. 빌드 및 실행
- Xcode에서 **MVVMi-v2** 스킴 선택
- **⌘ + R** 키로 시뮬레이터에서 실행
- 또는 실제 기기에서 실행

## 🧪 테스트

### 단위 테스트 실행

#### Xcode에서 테스트
```bash
# 전체 테스트 실행
⌘ + U

# 특정 타겟 테스트
# Test Navigator에서 개별 테스트 선택 후 실행
```

#### 커맨드 라인에서 테스트
```bash
# 전체 프로젝트 테스트
tuist test

# 특정 스킴만 테스트
tuist test MVVMi-v2

# 특정 타겟만 테스트
tuist test --test-targets "DomainTests"

# 시뮬레이터 지정하여 테스트
tuist test --device "iPhone 15 Pro" --os "17.0"
```

#### 상세 테스트 옵션
```bash
# 코드 커버리지 포함 테스트
tuist test --code-coverage

# 병렬 테스트 실행
tuist test --parallel-testing-enabled

# 특정 테스트만 실행
tuist test --test-plan "UnitTests"
```

### 테스트 구조
```
Tests/
├── DomainTests/
│   ├── InteractorTests/
│   │   └── QuotesInteractorTests.swift
│   └── ModelTests/
│       └── QuoteTests.swift
├── DataTests/
│   └── RepositoryTests/
│       └── QuoteRepositoryTests.swift
├── PresentationTests/
│   └── ViewModelTests/
│       └── MainViewModelTests.swift
└── MVVMi-v2Tests/
    └── IntegrationTests.swift
```

## 🔧 개발 환경 설정

### Tuist 프로젝트 편집
```bash
# 프로젝트 설정 편집을 위한 임시 프로젝트 생성
tuist edit

# 편집 후 다시 생성
tuist generate
```

### 캐시 관리
```bash
# 캐시 정리
tuist clean

# 원격 캐시 사용 (팀 개발시)
tuist cache warm
```

### 프로젝트 그래프 확인
```bash
# 의존성 그래프 생성
tuist graph

# 특정 타겟만 그래프 생성
tuist graph --target MVVMi-v2
```

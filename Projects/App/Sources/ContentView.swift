import SwiftUI
import Domain
import Data
import Presentation

struct ContentView: View {
    private let viewModel: MainViewModel
    
    init() {
        self.viewModel = DefaultDIContainer.shared.resolve(MainViewModel.self)
    }
    
    var body: some View {
        MainView(viewModel: viewModel)
    }
}

#Preview {
    ContentView()
}

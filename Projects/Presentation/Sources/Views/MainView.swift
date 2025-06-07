import SwiftUI
import Domain

public struct MainView: View {
    @StateObject private var viewModel: MainViewModel
    
    public init(viewModel: MainViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                VStack(spacing: 10) {
                    Image(systemName: "quote.bubble.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)
                    
                    Text("철학 명언")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                if viewModel.isLoading {
                    loadingView
                } else if let quote = viewModel.quote {
                    quoteCard(quote: quote)
                } else {
                    emptyView
                }
                
                Spacer()
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                
                Button(action: {
                    viewModel.send(.새로운명언_가져오기)
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("새로운 명언")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                .disabled(viewModel.isLoading)
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
        .onAppear {
            viewModel.send(.새로운명언_가져오기)
        }
    }
}

extension MainView {
    private var loadingView: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
            Text("명언을 불러오는 중...")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top)
        }
    }
    
    private func quoteCard(quote: Quote) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("\"")
                .font(.system(size: 60))
                .foregroundColor(.blue)
                .opacity(0.3)
                .offset(x: -10, y: 10)
            
            Text(quote.content)
                .font(.title2)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .padding(.horizontal)
            
            HStack {
                Spacer()
                Text("- \(quote.author)")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.trailing)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
    
    private var emptyView: some View {
        VStack {
            Image(systemName: "quote.bubble")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            Text("명언을 불러와주세요")
                .font(.headline)
                .foregroundColor(.gray)
        }
    }
}

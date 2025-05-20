import SwiftUI

struct CatDetailView: View {
    @StateObject private var viewModel: CatDetailViewModel

    init(cat: Cat) {
        _viewModel = StateObject(wrappedValue: CatDetailViewModel(cat: cat))
    }

    var body: some View {
        VStack(spacing: 16) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: UIScreen.main.bounds.height * 0.4)
            } else {
                ProgressView("Loading...")
                    .frame(height: UIScreen.main.bounds.height * 0.4)
            }

            HStack {
                Text("Say - ")
                    .font(.headline)
                TextField("Type a text...", text: $viewModel.sayText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit {
                        Task {
                            await viewModel.loadSayingImage()
                        }
                    }
            }
            .padding(.horizontal)

            Spacer()
        }
        .navigationTitle("Cat: \(viewModel.cat.id)")
        .task {
            await viewModel.loadDefaultImage()
        }
        .alert(isPresented: Binding<Bool>(
            get: { viewModel.errorMessage != nil },
            set: { _ in viewModel.clearError() })
        ) {
            Alert(title: Text("Error"),
                  message: Text(viewModel.errorMessage ?? ""),
                  dismissButton: .default(Text("OK")))
        }
    }
}

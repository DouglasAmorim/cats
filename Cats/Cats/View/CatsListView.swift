import SwiftUI

struct CatsListView: View {
    @StateObject private var viewModel: CatViewModel = CatViewModel()

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading cats...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(viewModel.cats, id: \.id) { cat in
                            NavigationLink(destination: CatDetailView(cat: cat)) {
                                HStack(alignment: .top, spacing: 12) {
                                    if let image = viewModel.images[cat.id] {
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: 80, height: 80)
                                            .cornerRadius(8)
                                    } else {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 80, height: 80)
                                            .cornerRadius(8)
                                            .overlay(ProgressView())
                                    }

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("ID: \(cat.id)")
                                            .font(.headline)
                                        if !cat.tags.isEmpty {
                                            Text("Tags: \(cat.tags.joined(separator: ", "))")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }

                        if !viewModel.isAllLoaded {
                            HStack {
                                Spacer()
                                if viewModel.isLoadingMore {
                                    ProgressView()
                                        .padding()
                                } else {
                                    Button("Load more cats") {
                                        Task {
                                            await viewModel.loadMoreCats()
                                        }
                                    }
                                    .padding()
                                }
                                Spacer()
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Cats")
            .task {
                await viewModel.loadCats()
            }
            .alert(isPresented: Binding<Bool>(
                get: { viewModel.errorMessage != nil },
                set: { _ in viewModel.clearError() })
            ) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

import Foundation
import SwiftUI

@MainActor
class CatViewModel: ObservableObject {
    @Published var cats: [Cat] = []
    @Published var images: [String: UIImage] = [:]
    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var errorMessage: String?
    @Published var isAllLoaded: Bool = false

    private var currentOffset: Int = 0
    private let pageSize = 10

    private let service: CatService

    init(service: CatService = CatService()) {
        self.service = service
    }

    func loadCats() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let fetched = try await service.fetchCats(skip: 0, limit: pageSize)
            cats = fetched
            currentOffset = fetched.count
            isAllLoaded = fetched.count < pageSize

            await fetchImages(for: fetched)
        } catch {
            errorMessage = "Erro ao carregar gatos: \(error.localizedDescription)"
        }
    }

    func loadMoreCats() async {
        guard !isLoadingMore && !isAllLoaded else { return }

        isLoadingMore = true
        defer { isLoadingMore = false }

        do {
            let fetched = try await service.fetchCats(skip: currentOffset, limit: pageSize)
            cats.append(contentsOf: fetched)
            currentOffset += fetched.count
            isAllLoaded = fetched.count < pageSize

            await fetchImages(for: fetched)
        } catch {
            errorMessage = "Error on load cats: \(error.localizedDescription)"
        }
    }

    private func fetchImages(for newCats: [Cat]) async {
        await withTaskGroup(of: (String, UIImage?).self) { group in
            for cat in newCats {
                group.addTask {
                    let data = try? await self.service.fetchCatImage(id: cat.id)
                    return (cat.id, data.flatMap { UIImage(data: $0) })
                }
            }

            for await (id, image) in group {
                if let image = image {
                    self.images[id] = image
                }
            }
        }
    }

    func clearError() {
        errorMessage = nil
    }
}

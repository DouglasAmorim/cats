import Foundation
import SwiftUI

@MainActor
class CatDetailViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var sayText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    let cat: Cat
    private let service: CatsService

    init(cat: Cat, service: CatsService = CatsService()) {
        self.cat = cat
        self.service = service
    }

    func loadDefaultImage() async {
        do {
            let data = try await service.fetchCatImage(id: cat.id)
            self.image = UIImage(data: data)
        } catch {
            errorMessage = "Error on loading image: \(error.localizedDescription)"
        }
    }

    func loadSayingImage() async {
        guard !sayText.isEmpty else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let data = try await service.fetchCatSayImage(id: cat.id, text: sayText)
            self.image = UIImage(data: data)
        } catch {
            errorMessage = "Error on loading Text: \(error.localizedDescription)"
        }
    }

    func clearError() {
        errorMessage = nil
    }
}

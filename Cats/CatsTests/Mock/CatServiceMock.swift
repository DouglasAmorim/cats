@testable import Cats
import SwiftUI

final class CatServiceMock: CatsService {
    
    private func fakeImageData() -> Data {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1))
        let image = renderer.image { ctx in
            UIColor.red.setFill()
            ctx.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        }
        return image.pngData() ?? Data()
    }
    
    override func fetchCats(tags: [String]? = nil, skip: Int? = nil, limit: Int = 10) async throws -> [Cat] {
        let totalCats = (0..<30).map { index in
            Cat(id: "\(index)", tags: ["mock"],  mimetype: "", createdAt: "")
        }

        let start = skip ?? 0
        let end = min(start + limit, totalCats.count)

        if start >= totalCats.count {
            return []
        }

        return Array(totalCats[start..<end])
    }

    override func fetchTags() async throws -> [String] {
        return ["tag1", "tag2"]
    }

    override func fetchCatImage(id: String) async throws -> Data {
        return fakeImageData()
    }

    override func fetchCatSayImage(id: String, text: String) async throws -> Data {
        return fakeImageData()
    }
}

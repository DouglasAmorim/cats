import Foundation

final class CatService {
    private let baseURL = URL(string: "https://cataas.com")!
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchCats(tags: [String]? = nil,
                   skip: Int? = nil,
                   limit: Int = 10) async throws -> [Cat] {
        let endpoint = Endpoint.cats(tags: tags, skip: skip, limit: limit)
        return try await request(endpoint: endpoint)
    }

    func fetchTags() async throws -> [String] {
        let endpoint = Endpoint.tags
        return try await request(endpoint: endpoint)
    }

    func fetchCatImage(id: String) async throws -> Data {
        let endpoint = Endpoint.catImage(id: id)

        var components = URLComponents(url: baseURL.appendingPathComponent(endpoint.path), resolvingAgainstBaseURL: false)!
        components.queryItems = endpoint.queryItems

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        let (data, _) = try await session.data(from: url)
        return data
    }
    
    func fetchCatSayImage(id: String, text: String) async throws -> Data {
        let endpoint = Endpoint.sayImage(id: id, text: text)
        var components = URLComponents(url: baseURL.appendingPathComponent(endpoint.path), resolvingAgainstBaseURL: false)!
        components.queryItems = endpoint.queryItems

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        let (data, _) = try await session.data(from: url)
        return data
    }

    private func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        var components = URLComponents(url: baseURL.appendingPathComponent(endpoint.path), resolvingAgainstBaseURL: false)!
        components.queryItems = endpoint.queryItems

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}

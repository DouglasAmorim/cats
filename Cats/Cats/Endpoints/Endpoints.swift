import Foundation

enum Endpoint {
    case cats(tags: [String]?, skip: Int?, limit: Int)
    case tags
    case catImage(id: String)
    case sayImage(id: String, text: String)

    var path: String {
        switch self {
        case .cats:
            return "/api/cats"
        case .tags:
            return "/api/tags"
        case let .catImage(id):
            return "/cat/\(id)"
        case let .sayImage(id, text):
            let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
            return "/cat/\(id)/says/\(encodedText)"
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case let .cats(tags, skip, limit):
            var items = [URLQueryItem(name: "limit", value: "\(limit)")]
            if let tags = tags, !tags.isEmpty {
                items.append(URLQueryItem(name: "tags", value: tags.joined(separator: ",")))
            }
            if let skip = skip {
                items.append(URLQueryItem(name: "skip", value: "\(skip)"))
            }
            return items
        case .tags, .catImage, .sayImage:
            return nil
        }
    }
}

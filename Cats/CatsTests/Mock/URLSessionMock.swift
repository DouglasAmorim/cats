@testable import Cats
import SwiftUI

final class URLSessionMock: URLSessionProtocol {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?

    init(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil) {
        self.mockData = data
        self.mockResponse = response
        self.mockError = error
    }

    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }

        let data = mockData ?? Data()
        let response = mockResponse ?? HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!

        return (data, response)
    }

    static func withJSON<T: Encodable>(_ object: T) -> URLSessionMock {
        let data = try? JSONEncoder().encode(object)
        return URLSessionMock(data: data)
    }
}

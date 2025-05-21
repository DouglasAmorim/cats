import XCTest
@testable import Cats

final class CatsServiceTests: XCTestCase {
    var sut: CatsService!

    override func setUp() {
        super.setUp()
        sut = CatsService(session: URLSessionMock())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_fetchCats_success() async throws {
        //Given
        let mockCats = [
            Cat(id: "1", tags: ["cute"], mimetype: "", createdAt: "")
        ]
        let mockSession = URLSessionMock.withJSON(mockCats)
        let sut = CatsService(session: mockSession)
        
        //When
        let result = try await sut.fetchCats(limit: 1)

        //Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].id, "1")
    }

    func test_fetchTags_success() async throws {
        //Given
        let mockTags = ["cute", "funny"]
        let mockSession = URLSessionMock.withJSON(mockTags)
        let sut = CatsService(session: mockSession)

        //When
        let result = try await sut.fetchTags()
        
        //Then
        XCTAssertEqual(result, mockTags)
    }

    func test_fetchCatImage_success() async throws {
        //Given
        let fakeImageData = Data([0xFF, 0xD8, 0xFF])
        let mockSession = URLSessionMock(data: fakeImageData)
        let sut = CatsService(session: mockSession)

        //When
        let result = try await sut.fetchCatImage(id: "abc")
        
        //Then
        XCTAssertEqual(result, fakeImageData)
    }

    func test_fetchSayImage_success() async throws {
        //Given
        let fakeImageData = Data([0xFF, 0xD8, 0xFF])
        let mockSession = URLSessionMock(data: fakeImageData)
        let sut = CatsService(session: mockSession)

        //When
        let result = try await sut.fetchCatSayImage(id: "valid-id", text: "hello")
        
        //Then
        XCTAssertEqual(result, fakeImageData)
    }
}

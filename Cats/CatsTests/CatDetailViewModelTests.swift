import XCTest
@testable import Cats

@MainActor
final class CatDetailViewModelTests: XCTestCase {
    var sut: CatDetailViewModel!

    override func setUp() {
        let mockCat = Cat(id: "abc", tags: ["cute"], mimetype: "", createdAt: "")
        sut = CatDetailViewModel(cat: mockCat, service: CatServiceMock())
    }

    override func tearDown() {
        sut = nil
    }

    func test_loadDefaultImage_shouldLoadImage() async {
        //When
        await sut.loadDefaultImage()
        
        //Then
        XCTAssertNotNil(sut.image)
    }

    func test_loadSayingImage_shouldUpdateImage() async {
        //Given
        sut.sayText = "hello"
        
        //When
        await sut.loadSayingImage()
        
        //Then
        XCTAssertNotNil(sut.image)
    }
}

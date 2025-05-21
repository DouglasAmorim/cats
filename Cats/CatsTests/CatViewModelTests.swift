import XCTest
@testable import Cats

@MainActor
final class CatViewModelTests: XCTestCase {
    var sut: CatViewModel!

    override func setUp() {
        sut = CatViewModel(service: CatServiceMock())
    }

    override func tearDown() {
        sut = nil
    }

    func test_loadCats_shouldPopulateCatsAndImages() async {
        //When
        await sut.loadCats()
        
        //Then
        XCTAssertEqual(sut.cats.count, 10)
        XCTAssertEqual(sut.images.count, 10)
    }

    func test_loadMoreCats_shouldAppendCats() async {
        //Given
        await sut.loadCats()
        let initialCount = sut.cats.count
        
        //When
        await sut.loadMoreCats()
        
        //Then
        XCTAssertTrue(sut.cats.count > initialCount)
    }
}

import XCTest
@testable import ImageMod

final class TintTests: ModTests {

    func test_itUsesColor() {

        _ = mod
            .tinted(.red)
            .image

        XCTAssertEqual(mod.info.tint, .red)
    }

    func testChaining_itUsesLastColor() {

        _ = mod
            .tinted(.blue)
            .tinted(.red)
            .image

        XCTAssertEqual(mod.info.tint, .red)
    }
}

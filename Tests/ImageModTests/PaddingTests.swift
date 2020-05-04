import XCTest
@testable import ImageMod

final class PaddingTests: ModTests {

    func test_itChangesOriginAndCanvasSize() {

        _ = mod
            .padded(top: 1, left: 2, bottom: 3, right: 4)
            .image

        XCTAssertEqual(mod.info.canvasSize, CGSize(width: 106, height: 104))
        XCTAssertEqual(mod.info.drawRect, CGRect(x: 2, y: 1, width: 100, height: 100))
    }

    func testChaining_itCombinesChanges() {

        _ = mod
            .padded(top: 1, left: 2, bottom: 3, right: 4)
            .padded(top: 4, left: 3, bottom: 2, right: 1)
            .image

        XCTAssertEqual(mod.info.canvasSize, CGSize(width: 110, height: 110))
        XCTAssertEqual(mod.info.drawRect, CGRect(x: 5, y: 5, width: 100, height: 100))
    }

    func testInsets_itChangesOriginAndCanvasSize() {

        _ = mod
            .padded(UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4))
            .image

        XCTAssertEqual(mod.info.canvasSize, CGSize(width: 106, height: 104))
        XCTAssertEqual(mod.info.drawRect, CGRect(x: 2, y: 1, width: 100, height: 100))
    }

    func testByLength_itChangesOriginAndCanvasSizeToAllSidesEqually() {

        _ = mod
            .padded(by: 1)
            .image

        XCTAssertEqual(mod.info.canvasSize, CGSize(width: 102, height: 102))
        XCTAssertEqual(mod.info.drawRect, CGRect(x: 1, y: 1, width: 100, height: 100))
    }
}

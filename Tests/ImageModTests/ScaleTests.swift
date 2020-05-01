import XCTest
@testable import ImageMod

final class ScaleTests: ModTests {

    func test_itChangesSizeAndCanvas() {

        _ = mod
            .scaled(to: CGSize(width: 1, height: 2))
            .image

        XCTAssertEqual(mod.info.canvasSize, CGSize(width: 1, height: 2))
        XCTAssertEqual(mod.info.drawRect, CGRect(x: 0, y: 0, width: 1, height: 2))
    }

    func test_itScalesPadding() {

        _ = mod
            .padded(by: 100)
            .scaled(to: CGSize(width: 3, height: 6))
            .image

        XCTAssertEqual(mod.info.canvasSize, CGSize(width: 3, height: 6))
        XCTAssertEqual(mod.info.drawRect, CGRect(x: 1, y: 2, width: 1, height: 2))
    }

    func testChaining_itUsesLastSize() {

        _ = mod
            .scaled(to: CGSize(width: 10, height: 20))
            .scaled(to: CGSize(width: 1, height: 2))
            .image

        XCTAssertEqual(mod.info.canvasSize, CGSize(width: 1, height: 2))
        XCTAssertEqual(mod.info.drawRect, CGRect(x: 0, y: 0, width: 1, height: 2))
    }

    func testTimes_itMultipliesSizeAndCanvas() {

        _ = mod
            .scaled(times: 2)
            .image

        XCTAssertEqual(mod.info.canvasSize, CGSize(width: 200, height: 200))
        XCTAssertEqual(mod.info.drawRect, CGRect(x: 0, y: 0, width: 200, height: 200))
    }

    func testWidth_itChangesWidthPerservingAspectRatio() {

        _ = mod
            .scaled(to: CGSize(width: 100, height: 50))
            .scaled(width: 2)
            .image

        XCTAssertEqual(mod.info.canvasSize, CGSize(width: 2, height: 1))
        XCTAssertEqual(mod.info.drawRect, CGRect(x: 0, y: 0, width: 2, height: 1))
    }

    func testHeight_itChangesHeightPerservingAspectRatio() {

        _ = mod
            .scaled(to: CGSize(width: 100, height: 50))
            .scaled(height: 1)
            .image

        XCTAssertEqual(mod.info.canvasSize, CGSize(width: 2, height: 1))
        XCTAssertEqual(mod.info.drawRect, CGRect(x: 0, y: 0, width: 2, height: 1))
    }

}

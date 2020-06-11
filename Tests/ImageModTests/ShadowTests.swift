import XCTest
@testable import ImageMod

final class ShadowTests: ModTests {

    func test_itUsesShadowAndAddsPaddingForIt() {

        _ = mod
            .shadowed(offset: CGPoint(x: 2, y: 4), blur: 10, color: .red)
            .image

        XCTAssertEqual(mod.info.shadow?.offset, CGPoint(x: 2, y: 4))
        XCTAssertEqual(mod.info.shadow?.blur, 10)
        XCTAssertEqual(mod.info.shadow?.color, .red)

        XCTAssertEqual(mod.info.canvasSize, CGSize(width: 120, height: 120))
        XCTAssertEqual(mod.info.drawRect, CGRect(x: 8, y: 6, width: 100, height: 100))
    }

    func test_itHandlesOffsetLargerThanBlur() {

        _ = mod
            .shadowed(offset: CGPoint(x: 20, y: 40), blur: 10)
            .image

        XCTAssertEqual(mod.info.shadow?.offset, CGPoint(x: 20, y: 40))
        XCTAssertEqual(mod.info.shadow?.blur, 10)

        XCTAssertEqual(mod.info.canvasSize, CGSize(width: 130, height: 150))
        XCTAssertEqual(mod.info.drawRect, CGRect(x: 0, y: 0, width: 100, height: 100))

    }

    func test_itUsesDefaultOffsetAndColor() {

        _ = mod
            .shadowed(blur: 10)
            .image

        XCTAssertEqual(mod.info.shadow?.offset, .zero)
        XCTAssertEqual(mod.info.shadow?.blur, 10)
        XCTAssertEqual(mod.info.shadow?.color, UIColor.black.withAlphaComponent(1/3))
    }

    func testChaining_itUsesLastShadow() {

        _ = mod
            .shadowed(blur: 10, color: .red)
            .shadowed(blur: 20, color: .blue)
            .image

        XCTAssertEqual(mod.info.shadow?.blur, 20)
        XCTAssertEqual(mod.info.shadow?.color, .blue)
    }
}

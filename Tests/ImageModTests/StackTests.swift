import XCTest
@testable import ImageMod

final class StackTests: ModTests {

    var mod2: MockMod!
    var mod3: MockMod!
    var mod4: MockMod!

    override func setUp() {
        mod  = MockMod(CGSize(width: 100, height: 100))
        mod2 = MockMod(CGSize(width: 200, height: 200))
        mod3 = MockMod(CGSize(width: 200, height: 100))
        mod4 = MockMod(CGSize(width: 100, height: 200))
    }

    // MARK: HStack

    func testHStack_itAddsImageOnTheRight() {

        _ = mod
            .hStack(mod3)
            .image

        XCTAssertEqual(mod.info.canvasSize,  CGSize(width: 300, height: 100))
        XCTAssertEqual(mod3.info.canvasSize, CGSize(width: 300, height: 100))

        XCTAssertEqual(mod.info.drawRect,  CGRect(x: 0,   y: 0, width: 100, height: 100))
        XCTAssertEqual(mod3.info.drawRect, CGRect(x: 100, y: 0, width: 200, height: 100))
    }

    func testHStackSpacing_itAddsImageOnTheRightWithSpace() {

        _ = mod
            .hStack(mod3, spacing: 10)
            .image

        XCTAssertEqual(mod.info.canvasSize,  CGSize(width: 310, height: 100))
        XCTAssertEqual(mod3.info.canvasSize, CGSize(width: 310, height: 100))

        XCTAssertEqual(mod.info.drawRect,  CGRect(x: 0,   y: 0, width: 100, height: 100))
        XCTAssertEqual(mod3.info.drawRect, CGRect(x: 110, y: 0, width: 200, height: 100))
    }

    func testHStackAlignment_itAddsImageOnTheRightWithAlignment() {

        let tests: [UIStackView.Alignment: CGRect] = [
            .fill:     CGRect(x: 200, y: 0,   width: 400, height: 200),
            .leading:  CGRect(x: 200, y: 0,   width: 200, height: 100),
            .center:   CGRect(x: 200, y: 50,  width: 200, height: 100),
            .trailing: CGRect(x: 200, y: 100, width: 200, height: 100),
        ]

        tests.forEach { alignment, drawRect in

            _ = mod2
                .hStack(mod3, alignment: alignment)
                .image

            XCTAssertEqual(mod2.info.canvasSize, CGSize(width: 200 + drawRect.width, height: 200))
            XCTAssertEqual(mod3.info.canvasSize, CGSize(width: 200 + drawRect.width, height: 200))

            XCTAssertEqual(mod2.info.drawRect, CGRect(x: 0, y: 0, width: 200, height: 200))
            XCTAssertEqual(mod3.info.drawRect, drawRect)

        }
    }

    func testHStackArray_itAddsAllImages() {

        _ = [mod2, mod, mod3, mod4]
            .hStack(spacing: 10)
            .image

        XCTAssertEqual(mod.info.canvasSize,  CGSize(width: 630, height: 200))
        XCTAssertEqual(mod2.info.canvasSize, CGSize(width: 630, height: 200))
        XCTAssertEqual(mod3.info.canvasSize, CGSize(width: 630, height: 200))
        XCTAssertEqual(mod4.info.canvasSize, CGSize(width: 630, height: 200))

        XCTAssertEqual(mod.info.drawRect,  CGRect(x: 210, y: 50, width: 100, height: 100))
        XCTAssertEqual(mod2.info.drawRect, CGRect(x: 0,   y: 0,  width: 200, height: 200))
        XCTAssertEqual(mod3.info.drawRect, CGRect(x: 320, y: 50, width: 200, height: 100))
        XCTAssertEqual(mod4.info.drawRect, CGRect(x: 530, y: 0,  width: 100, height: 200))
    }

    // MARK: VStack

    func testVStack_itAddsImageOnTheBottom() {

        _ = mod
            .vStack(mod4)
            .image

        XCTAssertEqual(mod.info.canvasSize,  CGSize(width: 100, height: 300))
        XCTAssertEqual(mod4.info.canvasSize, CGSize(width: 100, height: 300))

        XCTAssertEqual(mod.info.drawRect,  CGRect(x: 0, y: 0,   width: 100, height: 100))
        XCTAssertEqual(mod4.info.drawRect, CGRect(x: 0, y: 100, width: 100, height: 200))
    }

    func testVStackSpacing_itAddsImageOnTheRightWithSpace() {

        _ = mod
            .vStack(mod4, spacing: 10)
            .image

        XCTAssertEqual(mod.info.canvasSize,  CGSize(width: 100, height: 310))
        XCTAssertEqual(mod4.info.canvasSize, CGSize(width: 100, height: 310))

        XCTAssertEqual(mod.info.drawRect,  CGRect(x: 0, y: 0,   width: 100, height: 100))
        XCTAssertEqual(mod4.info.drawRect, CGRect(x: 0, y: 110, width: 100, height: 200))
    }

    func testVStackAlignment_itAddsImageOnTheBottomWithAlignment() {

        let tests: [UIStackView.Alignment: CGRect] = [
            .fill:     CGRect(x: 0,   y: 200, width: 200, height: 400),
            .leading:  CGRect(x: 0,   y: 200, width: 100, height: 200),
            .center:   CGRect(x: 50,  y: 200, width: 100, height: 200),
            .trailing: CGRect(x: 100, y: 200, width: 100, height: 200),
        ]

        tests.forEach { alignment, drawRect in

            _ = mod2
                .vStack(mod4, alignment: alignment)
                .image

            XCTAssertEqual(mod2.info.canvasSize, CGSize(width: 200, height: 200 + drawRect.height))
            XCTAssertEqual(mod4.info.canvasSize, CGSize(width: 200, height: 200 + drawRect.height))

            XCTAssertEqual(mod2.info.drawRect, CGRect(x: 0, y: 0, width: 200, height: 200))
            XCTAssertEqual(mod4.info.drawRect, drawRect)

        }
    }

    func testVStackArray_itAddsAllImages() {

        _ = [mod2, mod, mod3, mod4]
            .vStack(spacing: 10)
            .image

        XCTAssertEqual(mod.info.canvasSize,  CGSize(width: 200, height: 630))
        XCTAssertEqual(mod2.info.canvasSize, CGSize(width: 200, height: 630))
        XCTAssertEqual(mod3.info.canvasSize, CGSize(width: 200, height: 630))
        XCTAssertEqual(mod4.info.canvasSize, CGSize(width: 200, height: 630))

        XCTAssertEqual(mod.info.drawRect,  CGRect(x: 50, y: 210, width: 100, height: 100))
        XCTAssertEqual(mod2.info.drawRect, CGRect(x: 0,  y: 0,   width: 200, height: 200))
        XCTAssertEqual(mod3.info.drawRect, CGRect(x: 0,  y: 320, width: 200, height: 100))
        XCTAssertEqual(mod4.info.drawRect, CGRect(x: 50, y: 430, width: 100, height: 200))
    }

    // MARK: ZStack

    func testZStack_itAddsHorizontalImageOnTopWithAlignment() {

        let tests: [UIView.ContentMode: CGRect] = [
            .scaleToFill:     CGRect(x: 0,    y: 0,   width: 200, height: 200),
            .scaleAspectFit:  CGRect(x: 0,    y: 50,  width: 200, height: 100),
            .scaleAspectFill: CGRect(x: -100, y: 0,   width: 400, height: 200),
            .center:          CGRect(x: 50,   y: 75,  width: 100, height: 50),
            .top:             CGRect(x: 50,   y: 0,   width: 100, height: 50),
            .bottom:          CGRect(x: 50,   y: 150, width: 100, height: 50),
            .left:            CGRect(x: 0,    y: 75,  width: 100, height: 50),
            .right:           CGRect(x: 100,  y: 75,  width: 100, height: 50),
            .topLeft:         CGRect(x: 0,    y: 0,   width: 100, height: 50),
            .topRight:        CGRect(x: 100,  y: 0,   width: 100, height: 50),
            .bottomLeft:      CGRect(x: 0,    y: 150, width: 100, height: 50),
            .bottomRight:     CGRect(x: 100,  y: 150, width: 100, height: 50),
        ]

        tests.forEach { alignment, drawRect in

            _ = mod2
                .zStack(mod3.scaled(times: 0.5), alignment: alignment)
                .image

            XCTAssertEqual(mod2.info.canvasSize, CGSize(width: 200, height: 200))
            XCTAssertEqual(mod3.info.canvasSize, CGSize(width: 200, height: 200))

            XCTAssertEqual(mod2.info.drawRect, CGRect(x: 0, y: 0, width: 200, height: 200))
            XCTAssertEqual(mod3.info.drawRect, drawRect)

        }
    }

    func testZStack_itAddsVerticalImageOnTopWithAlignment() {

        let tests: [UIView.ContentMode: CGRect] = [
            .scaleToFill:     CGRect(x: 0,   y: 0,    width: 200, height: 200),
            .scaleAspectFit:  CGRect(x: 50,  y: 0,    width: 100, height: 200),
            .scaleAspectFill: CGRect(x: 0,   y: -100, width: 200, height: 400),
            .center:          CGRect(x: 75,  y: 50,   width: 50,  height: 100),
            .top:             CGRect(x: 75,  y: 0,    width: 50,  height: 100),
            .bottom:          CGRect(x: 75,  y: 100,  width: 50,  height: 100),
            .left:            CGRect(x: 0,   y: 50,   width: 50,  height: 100),
            .right:           CGRect(x: 150, y: 50,   width: 50,  height: 100),
            .topLeft:         CGRect(x: 0,   y: 0,    width: 50,  height: 100),
            .topRight:        CGRect(x: 150, y: 0,    width: 50,  height: 100),
            .bottomLeft:      CGRect(x: 0,   y: 100,  width: 50,  height: 100),
            .bottomRight:     CGRect(x: 150, y: 100,  width: 50,  height: 100),
        ]

        tests.forEach { alignment, drawRect in

            _ = mod2
                .zStack(mod4.scaled(times: 0.5), alignment: alignment)
                .image

            XCTAssertEqual(mod2.info.canvasSize, CGSize(width: 200, height: 200))
            XCTAssertEqual(mod4.info.canvasSize, CGSize(width: 200, height: 200))

            XCTAssertEqual(mod2.info.drawRect, CGRect(x: 0, y: 0, width: 200, height: 200))
            XCTAssertEqual(mod4.info.drawRect, drawRect)

        }
    }

    func testZStackArray_itAddsAllImages() {

        _ = [mod2, mod, mod3, mod4]
            .zStack()
            .image

        XCTAssertEqual(mod.info.canvasSize,  CGSize(width: 200, height: 200))
        XCTAssertEqual(mod2.info.canvasSize, CGSize(width: 200, height: 200))
        XCTAssertEqual(mod3.info.canvasSize, CGSize(width: 200, height: 200))
        XCTAssertEqual(mod4.info.canvasSize, CGSize(width: 200, height: 200))

        XCTAssertEqual(mod.info.drawRect,  CGRect(x: 50, y: 50, width: 100, height: 100))
        XCTAssertEqual(mod2.info.drawRect, CGRect(x: 0,  y: 0,  width: 200, height: 200))
        XCTAssertEqual(mod3.info.drawRect, CGRect(x: 0,  y: 50, width: 200, height: 100))
        XCTAssertEqual(mod4.info.drawRect, CGRect(x: 50, y: 0,  width: 100, height: 200))
    }
}

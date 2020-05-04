import XCTest
@testable import ImageMod

final class UIImageTests: XCTestCase {

    func test_itDraws() {

        let blackSquare = UIGraphicsImageRenderer(size: CGSize(width: 10, height: 10)).image { context in
            UIColor.black.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 10, height: 10))
        }

        let sut = blackSquare
            .scaled(to: CGSize(width: 200, height: 100))
            .padded(by: 10)
            .tinted(.red)
            .image

        let image = UIGraphicsImageRenderer(size: CGSize(width: 220, height: 120)).image { context in
            UIColor.red.setFill()
            context.fill(CGRect(x: 10, y: 10, width: 200, height: 100))
        }

        XCTAssertEqual(sut.pngData(), image.pngData())
    }
}

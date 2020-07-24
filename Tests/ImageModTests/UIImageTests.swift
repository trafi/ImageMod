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
            .zStack(blackSquare
                .shadowed(offset: CGPoint(x: 2, y: 4), blur: 8, color: .green)
                .padded(top: 8, left: 4)
            )
            .hStack(blackSquare, spacing: 10, alignment: .top)
            .image

        let image = UIGraphicsImageRenderer(size: CGSize(width: 240, height: 120)).image { context in
            UIColor.red.setFill()
            context.fill(CGRect(x: 10, y: 10, width: 200, height: 100))

            UIColor.black.setFill()
            context.cgContext.setShadow(offset: CGSize(width: 2, height: 4), blur: 8, color: UIColor.green.cgColor)
            context.fill(CGRect(x: 105, y: 55, width: 10, height: 10))

            context.cgContext.setShadow(offset: .zero, blur: 0, color: nil)
            context.fill(CGRect(x: 230, y: 0, width: 10, height: 10))
        }

        XCTAssertEqual(sut.pngData(), image.pngData())
    }
}

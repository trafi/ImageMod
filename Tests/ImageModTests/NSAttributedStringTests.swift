import XCTest
@testable import ImageMod

final class NSAttributedStringTests: XCTestCase {

    func test_itDraws() {

        let sut = NSAttributedString(string: "Cats!")
            .tinted(.blue)
            .scaled(times: 4)
            .shadowed(offset: CGPoint(x: 5, y: 10), blur: 20, color: .red)
            .image


        let image = UIGraphicsImageRenderer(size: CGSize(width: 152.5, height: 95.5)).image { context in

            let shadow = NSShadow()
            shadow.shadowOffset = CGSize(width: 5, height: 10)
            shadow.shadowBlurRadius = 20
            shadow.shadowColor = UIColor.red

            let string = NSAttributedString(string: "Cats!", attributes: [
                .foregroundColor: UIColor.blue,
                .shadow: shadow,
                .font: UIFont(name: "Helvetica", size: 48)!
            ])

            string.draw(at: CGPoint(x: 15, y: 10))
        }

        XCTAssertEqual(sut.pngData(), image.pngData())
    }
}

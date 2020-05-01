import XCTest
@testable import ImageMod

class ModTests: XCTestCase {

    class MockMod: ImageModable {

        var initialSize: CGSize
        init(_ initialSize: CGSize = CGSize(width: 100, height: 100)) {
            self.initialSize = initialSize
        }

        var mod: ImageMod {
            ImageMod(info: ImageMod.Info(initialSize), draw: { self.info = $0 })
        }

        var info: ImageMod.Info!
    }

    var mod: MockMod!

    override func setUp() {
        mod = MockMod()
    }
}

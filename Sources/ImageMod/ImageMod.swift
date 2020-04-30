import UIKit

public struct ImageMod {

    struct Info {
        var canvasSize: CGSize
        var drawRect: CGRect
        var tint: UIColor?

        init(_ size: CGSize) {
            canvasSize = size
            drawRect = CGRect(origin: .zero, size: size)
            tint = nil
        }
    }

    var info: Info
    let draw: (Info) -> ()

    public var image: UIImage {
        UIGraphicsImageRenderer(size: info.canvasSize).image { _ in draw(info) }
    }
}

extension ImageMod: ImageModable {
    public var mod: ImageMod { self }
}

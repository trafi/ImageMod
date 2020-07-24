import UIKit

public struct ImageMod {

    struct Info {
        var canvasSize: CGSize
        var drawRect: CGRect
        var tint: UIColor?
        var shadow: (offset: CGPoint, blur: CGFloat, color: UIColor)?

        init(_ size: CGSize) {
            canvasSize = size
            drawRect = CGRect(origin: .zero, size: size)
            tint = nil
            shadow = nil
        }
    }

    var info: Info
    let draw: (Info) -> ()
}

extension ImageMod: ImageModable {
    public var mod: ImageMod { self }
}

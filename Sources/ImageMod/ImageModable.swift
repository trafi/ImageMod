import UIKit

public protocol ImageModable {
    var mod: ImageMod { get }
}

public extension ImageModable {

    // MARK: Tinted

    func tinted(_ tint: UIColor) -> ImageMod {
        with {
            $0.tint = tint
        }
    }

    // MARK: Padded

    func padded(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> ImageMod {
        with {
            $0.canvasSize.width += left + right
            $0.canvasSize.height += top + bottom
            $0.drawRect.origin.y += top
            $0.drawRect.origin.x += left
        }
    }

    func padded(by length: CGFloat) -> ImageMod {
        padded(top: length, left: length, bottom: length, right: length)
    }

    // MARK: Scaled

    func scaled(to size: CGSize) -> ImageMod {
        with {
            let multiplier = CGSize(width: size.width / $0.canvasSize.width,
                                    height: size.height / $0.canvasSize.height)
            $0.canvasSize = size
            $0.drawRect.origin.x *= multiplier.width
            $0.drawRect.origin.y *= multiplier.height
            $0.drawRect.size.width *= multiplier.width
            $0.drawRect.size.height *= multiplier.height
        }
    }

    func scaled(by multiplier: CGFloat) -> ImageMod {
        scaled(to: CGSize(width: info.canvasSize.width * multiplier,
                          height: info.canvasSize.height * multiplier)
        )
    }

    func scaled(width: CGFloat) -> ImageMod {
        scaled(by: width / info.canvasSize.width)
    }

    func scaled(height: CGFloat) -> ImageMod {
        scaled(by: height / info.canvasSize.height)
    }

    // MARK: Stack

    func zStack(_ overlay: ImageModable) -> ImageMod {
        with(overlay.mod)
    }

    func hStack(_ image: ImageModable) -> ImageMod {
        self
            .padded(right: image.info.canvasSize.width)
            .with(image.padded(left: info.canvasSize.width))
    }

    func vStack(_ image: ImageModable) -> ImageMod {
        self
            .padded(bottom: image.info.canvasSize.height)
            .with(image.padded(top: info.canvasSize.height))
    }
}

// MARK: - Base modifications

private extension ImageModable {

    var info: ImageMod.Info { mod.info }

    func with(_ changes: (inout ImageMod.Info) -> ()) -> ImageMod {
        var copy = mod
        changes(&copy.info)
        return copy
    }

    func with(_ overlay: ImageMod) -> ImageMod {
        ImageMod(info: mod.info) { info in

            self.mod.draw(info)

            var overlayInfo = overlay.info

            overlayInfo.tint = info.tint != self.mod.info.tint ? info.tint : overlay.info.tint

            overlayInfo.canvasSize.width *= info.canvasSize.width / self.info.canvasSize.width
            overlayInfo.canvasSize.height *= info.canvasSize.height / self.info.canvasSize.height

            overlayInfo.drawRect.size.width *= info.drawRect.width / self.info.drawRect.width
            overlayInfo.drawRect.size.height *= info.drawRect.height / self.info.drawRect.height

            overlayInfo.drawRect.origin.x -= self.info.drawRect.origin.x
            overlayInfo.drawRect.origin.x *= info.drawRect.width / self.info.drawRect.width
            overlayInfo.drawRect.origin.x += info.drawRect.origin.x

            overlayInfo.drawRect.origin.y -= self.info.drawRect.origin.y
            overlayInfo.drawRect.origin.y *= info.drawRect.height / self.info.drawRect.height
            overlayInfo.drawRect.origin.y += info.drawRect.origin.y

            overlay.draw(overlayInfo)
        }
    }
}

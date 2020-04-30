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

    func padded(_ insets: UIEdgeInsets) -> ImageMod {
        padded(top: insets.top, left: insets.left, bottom: insets.bottom, right: insets.right)
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

    func scaled(times multiplier: CGFloat) -> ImageMod {
        scaled(to: CGSize(width: info.canvasSize.width * multiplier,
                          height: info.canvasSize.height * multiplier)
        )
    }

    func scaled(width: CGFloat) -> ImageMod {
        scaled(times: width / info.canvasSize.width)
    }

    func scaled(height: CGFloat) -> ImageMod {
        scaled(times: height / info.canvasSize.height)
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

public extension Array where Element == ImageModable {

    func zStack(_ alignment: UIView.ContentMode = .center) -> ImageMod {
        guard let first = first?.mod else { return UIImage().mod }
        return dropFirst().reduce(first, alignment.zStack)
    }
}

private extension UIView.ContentMode {

    func zStack(base: ImageModable, overlay: ImageModable) -> ImageMod {
        base.zStack(
            overlay
                .scaled(to: scale(base.info.canvasSize, overlay.info.canvasSize))
                .padded(padding(base.info.canvasSize, overlay.info.canvasSize))
        )
    }

    func scale(_ canvas: CGSize, _ size: CGSize) -> CGSize {
        switch self {
        case .scaleToFill:
            return canvas
        case .scaleAspectFit:
            return canvas.aspect < size.aspect
                ? CGSize(width: canvas.width,
                         height: size.height * canvas.width / size.width)
                : CGSize(width: size.width * canvas.height / size.height,
                         height: canvas.height)
        case .scaleAspectFill:
            return canvas.aspect > size.aspect
                ? CGSize(width: canvas.width,
                         height: size.height * canvas.width / size.width)
                : CGSize(width: size.width * canvas.height / size.height,
                         height: canvas.height)
        default: return size
        }
    }

    func padding(_ canvas: CGSize, _ size: CGSize) -> UIEdgeInsets {
        UIEdgeInsets(top: top(canvas, size), left: left(canvas, size),
                     bottom: bottom(canvas, size), right: right(canvas, size))
    }

    func top(_ canvas: CGSize, _ size: CGSize) -> CGFloat {
        switch self {
        case .top, .topLeft, .topRight, .scaleToFill:
            return 0
        case .center, .left, .right:
            return (canvas.height - size.height) / 2
        case .bottom, .bottomLeft, .bottomRight:
            return canvas.height - size.height
        case .scaleAspectFit:
            return canvas.aspect < size.aspect
                ? (canvas.height - size.height * canvas.width / size.width) / 2
                : 0
        case .scaleAspectFill:
            return canvas.aspect > size.aspect
                ? (canvas.height - size.height * canvas.width / size.width) / 2
                : 0
        default: return 0
        }
    }

    func bottom(_ canvas: CGSize, _ size: CGSize) -> CGFloat {
        switch self {
        case .bottom, .bottomLeft, .bottomRight, .scaleToFill:
            return 0
        case .center, .left, .right:
            return (canvas.height - size.height) / 2
        case .top, .topLeft, .topRight:
            return canvas.height - size.height
        case .scaleAspectFit:
            return canvas.aspect < size.aspect
                ? (canvas.height - size.height * canvas.width / size.width) / 2
                : 0
        case .scaleAspectFill:
            return canvas.aspect > size.aspect
                ? (canvas.height - size.height * canvas.width / size.width) / 2
                : 0
        default: return 0
        }
    }

    func left(_ canvas: CGSize, _ size: CGSize) -> CGFloat {
        switch self {
        case .left, .topLeft, .bottomLeft, .scaleToFill:
            return 0
        case .center, .top, .bottom:
            return (canvas.width - size.width) / 2
        case .right, .topRight, .bottomRight:
            return canvas.width - size.width
        case .scaleAspectFit:
            return canvas.aspect > size.aspect
                ? (canvas.width - size.width * canvas.height / size.height) / 2
                : 0
        case .scaleAspectFill:
            return canvas.aspect < size.aspect
                ? (canvas.width - size.width * canvas.height / size.height) / 2
                : 0
        default: return 0
        }
    }

    func right(_ canvas: CGSize, _ size: CGSize) -> CGFloat {
        switch self {
        case .right, .topRight, .bottomRight, .scaleToFill:
            return 0
        case .center, .top, .bottom:
            return (canvas.width - size.width) / 2
        case .left, .topLeft, .bottomLeft:
            return canvas.width - size.width
        case .scaleAspectFit:
            return canvas.aspect > size.aspect
                ? (canvas.width - size.width * canvas.height / size.height) / 2
                : 0
        case .scaleAspectFill:
            return canvas.aspect < size.aspect
                ? (canvas.width - size.width * canvas.height / size.height) / 2
                : 0
        default: return 0
        }
    }
}

private extension CGSize {
    var aspect: CGFloat { width / height }
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

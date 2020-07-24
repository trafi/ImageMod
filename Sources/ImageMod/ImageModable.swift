import UIKit

public protocol ImageModable {
    var mod: ImageMod { get }
}

public extension ImageModable {

    var image: UIImage {
        UIGraphicsImageRenderer(size: canvasSize).image { _ in mod.draw(mod.info) }
    }

    // MARK: Tinted

    func tinted(_ tint: UIColor) -> ImageModable {
        with {
            $0.tint = tint
        }
    }

    // MARK: Shadowed

    func shadowed(offset: CGPoint = .zero, blur: CGFloat, color: UIColor = UIColor.black.withAlphaComponent(1/3)) -> ImageModable {
        padded(top: max(0, blur - offset.y),
               left: max(0, blur - offset.x),
               bottom: max(0, blur + offset.y),
               right: max(0, blur + offset.x))
            .with {
                $0.shadow = (offset, blur, color)
            }
    }

    // MARK: Padded

    func padded(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> ImageModable {
        with {
            $0.canvasSize.width += left + right
            $0.canvasSize.height += top + bottom
            $0.drawRect.origin.y += top
            $0.drawRect.origin.x += left
        }
    }

    func padded(_ insets: UIEdgeInsets) -> ImageModable {
        padded(top: insets.top, left: insets.left, bottom: insets.bottom, right: insets.right)
    }

    func padded(by length: CGFloat) -> ImageModable {
        padded(top: length, left: length, bottom: length, right: length)
    }

    // MARK: Scaled

    func scaled(to size: CGSize) -> ImageModable {
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

    func scaled(times multiplier: CGFloat) -> ImageModable {
        scaled(to: CGSize(width: canvasSize.width * multiplier,
                          height: canvasSize.height * multiplier)
        )
    }

    func scaled(width: CGFloat) -> ImageModable {
        scaled(times: width / canvasSize.width)
    }

    func scaled(height: CGFloat) -> ImageModable {
        scaled(times: height / canvasSize.height)
    }

    // MARK: Stack

    func hStack(_ image: ImageModable, spacing: CGFloat = 0, alignment: UIStackView.Alignment = .center) -> ImageModable {
        let rect = image.canvasSize.vAlign(in: canvasSize, alignment: alignment)
        return self
            .padded(right: rect.maxX + spacing)
            .with(image
                .scaled(to: rect.size)
                .padded(top: rect.minY,
                        left: canvasSize.width + spacing,
                        bottom: canvasSize.height - rect.maxY)
        )
    }

    func vStack(_ image: ImageModable, spacing: CGFloat = 0, alignment: UIStackView.Alignment = .center) -> ImageModable {
        let rect = image.canvasSize.hAlign(in: canvasSize, alignment: alignment)
        return self
            .padded(bottom: rect.maxY + spacing)
            .with(image
                .scaled(to: rect.size)
                .padded(top: canvasSize.height + spacing,
                        left: rect.minX,
                        right: canvasSize.width - rect.maxX)
        )
    }

    func zStack(_ overlay: ImageModable, alignment: UIView.ContentMode = .center) -> ImageModable {
        let rect = overlay.canvasSize.align(in: canvasSize, alignment: alignment)
        return with(overlay
            .scaled(to: rect.size)
            .padded(top: rect.minY,
                    left: rect.minX,
                    bottom: canvasSize.height - rect.maxY,
                    right: canvasSize.width - rect.maxX)
        )
    }
}

public extension Array where Element == ImageModable {

    func hStack(spacing: CGFloat = 0, alignment: UIStackView.Alignment = .center) -> ImageModable {
        stack { $0.hStack($1, spacing: spacing, alignment: alignment) }
    }

    func vStack(spacing: CGFloat = 0, alignment: UIStackView.Alignment = .center) -> ImageModable {
        stack { $0.vStack($1, spacing: spacing, alignment: alignment) }
    }

    func zStack(_ alignment: UIView.ContentMode = .center) -> ImageModable {
        stack { $0.zStack($1, alignment: alignment) }
    }

    private func stack(_ nextPartialResult: (ImageModable, ImageModable) -> ImageModable) -> ImageModable {
        guard let first = first else { return UIImage() }
        return dropFirst().reduce(first, nextPartialResult)
    }
}

// MARK: - Base modifications

private extension ImageModable {

    var canvasSize: CGSize { mod.info.canvasSize }
    var drawRect: CGRect { mod.info.drawRect }

    func with(_ changes: (inout ImageMod.Info) -> ()) -> ImageModable {
        var copy = mod
        changes(&copy.info)
        return copy
    }

    func with(_ overlay: ImageModable) -> ImageModable {
        ImageMod(info: mod.info) { info in

            self.mod.draw(info)

            var overlayInfo = overlay.mod.info

            overlayInfo.tint = info.tint != self.mod.info.tint ? info.tint : overlayInfo.tint

            overlayInfo.canvasSize.width *= info.canvasSize.width / self.canvasSize.width
            overlayInfo.canvasSize.height *= info.canvasSize.height / self.canvasSize.height

            overlayInfo.drawRect.size.width *= info.drawRect.width / self.drawRect.width
            overlayInfo.drawRect.size.height *= info.drawRect.height / self.drawRect.height

            overlayInfo.drawRect.origin.x -= self.drawRect.origin.x
            overlayInfo.drawRect.origin.x *= info.drawRect.width / self.drawRect.width
            overlayInfo.drawRect.origin.x += info.drawRect.origin.x

            overlayInfo.drawRect.origin.y -= self.drawRect.origin.y
            overlayInfo.drawRect.origin.y *= info.drawRect.height / self.drawRect.height
            overlayInfo.drawRect.origin.y += info.drawRect.origin.y

            overlay.mod.draw(overlayInfo)
        }
    }
}

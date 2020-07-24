import UIKit

extension NSAttributedString: ImageModable {

    public var mod: ImageMod {
        ImageMod(info: .init(size()),
                 draw: { info in
                    self.with(info.tint)
                        .with(info.drawRect.size)
                        .with(info.shadow)
                        .draw(in: info.drawRect)
        })
    }

    private func with(_ tint: UIColor?) -> NSAttributedString {
        guard let tint = tint else { return self }
        return with(.foregroundColor, tint)
    }

    private func with(_ size: CGSize) -> NSAttributedString {

        let currentSize = self.size()
        let scale = min(size.width / currentSize.width, size.height / currentSize.height)

        // https://developer.apple.com/documentation/foundation/nsattributedstring
        let defaultFont = UIFont(name: "Helvetica", size: 12)!
        let currentFont = attribute(.font, at: 0, effectiveRange: nil) as? UIFont ?? defaultFont

        let font = currentFont.withSize(currentFont.pointSize * scale)

        return with(.font, font)
    }

    private func with(_ shadow: (offset: CGPoint, blur: CGFloat, color: UIColor)?) -> NSAttributedString {

        guard let shadow = shadow else { return self }

        let nsShadow = NSShadow()
        nsShadow.shadowOffset = CGSize(width: shadow.offset.x, height: shadow.offset.y)
        nsShadow.shadowBlurRadius = shadow.blur
        nsShadow.shadowColor = shadow.color

        return with(.shadow, nsShadow)
    }

    private func with(_ key: NSAttributedString.Key, _ value: Any) -> NSAttributedString {

        let mutable = NSMutableAttributedString(attributedString: self)
        mutable.addAttribute(key, value: value,
                             range: NSRange(location: 0, length: string.utf16.count))

        return mutable
    }
}

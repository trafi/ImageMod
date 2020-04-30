import UIKit

extension UIImage: ImageModable {

    public var mod: ImageMod {
        ImageMod(info: .init(size),
                 draw: { info in
                    self.withTintColor(info.tint, optimizedFor: info.drawRect.size)
                        .draw(in: info.drawRect)
        })
    }

    private func withTintColor(_ tint: UIColor?, optimizedFor size: CGSize) -> UIImage {
        guard let tint = tint else { return self }
        if #available(iOS 13.0, *) {
            return withTintColor(tint)
        } else {
            return UIGraphicsImageRenderer(size: size).image { context in
                let rect = CGRect(origin: .zero, size: size)
                self.draw(in: rect)
                tint.setFill()
                context.fill(rect, blendMode: .sourceIn)
            }
        }
    }
}

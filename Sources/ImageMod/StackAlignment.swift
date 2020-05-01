import UIKit

extension CGSize {

    func vAlign(in canvas: CGSize, alignment: UIStackView.Alignment) -> CGRect {
        switch alignment {
        case .fill:
            return CGRect(origin: .zero, size: CGSize(width: canvas.height * aspect, height: canvas.height))
        case .leading:
            return CGRect(origin: .zero, size: self)
        case .center:
            return CGRect(origin: CGPoint(x: 0, y: (canvas.height - height) / 2), size: self)
        case .trailing:
            return CGRect(origin: CGPoint(x: 0, y: canvas.height - height), size: self)
        default:
            return CGRect(origin: .zero, size: self)
        }
    }

    func hAlign(in canvas: CGSize, alignment: UIStackView.Alignment) -> CGRect {
        switch alignment {
        case .fill:
            return CGRect(origin: .zero, size: CGSize(width: canvas.width, height: canvas.width / aspect))
        case .leading:
            return CGRect(origin: .zero, size: self)
        case .center:
            return CGRect(origin: CGPoint(x: (canvas.width - width) / 2, y: 0), size: self)
        case .trailing:
            return CGRect(origin: CGPoint(x: canvas.width - width, y: 0), size: self)
        default:
            return CGRect(origin: .zero, size: self)
        }
    }


    func align(in canvas: CGSize, alignment: UIView.ContentMode) -> CGRect {
        switch alignment {
        case .scaleToFill:
            return CGRect(origin: .zero, size: canvas)
        case .scaleAspectFit where aspect > canvas.aspect:
            return align(in: canvas, horizontal: .fill, vertical: .center)
        case .scaleAspectFit:
            return align(in: canvas, horizontal: .center, vertical: .fill)
        case .scaleAspectFill where aspect < canvas.aspect:
            return align(in: canvas, horizontal: .fill, vertical: .center)
        case .scaleAspectFill:
            return align(in: canvas, horizontal: .center, vertical: .fill)
        case .center:
            return align(in: canvas, horizontal: .center, vertical: .center)
        case .top:
            return align(in: canvas, horizontal: .center, vertical: .leading)
        case .bottom:
            return align(in: canvas, horizontal: .center, vertical: .trailing)
        case .left:
            return align(in: canvas, horizontal: .leading, vertical: .center)
        case .right:
            return align(in: canvas, horizontal: .trailing, vertical: .center)
        case .topLeft:
            return align(in: canvas, horizontal: .leading, vertical: .leading)
        case .topRight:
            return align(in: canvas, horizontal: .trailing, vertical: .leading)
        case .bottomLeft:
            return align(in: canvas, horizontal: .leading, vertical: .trailing)
        case .bottomRight:
            return align(in: canvas, horizontal: .trailing, vertical: .trailing)
        default:
            return CGRect(origin: .zero, size: self)
        }
    }

    private func align(in canvas: CGSize, horizontal: UIStackView.Alignment, vertical: UIStackView.Alignment) -> CGRect {

        let h, v: CGRect

        if horizontal == .fill {
            h = hAlign(in: canvas, alignment: horizontal)
            v = h.size.vAlign(in: canvas, alignment: vertical)
        } else if vertical == .fill {
            v = vAlign(in: canvas, alignment: vertical)
            h = v.size.hAlign(in: canvas, alignment: horizontal)
        } else {
            h = hAlign(in: canvas, alignment: horizontal)
            v = vAlign(in: canvas, alignment: vertical)
        }

        return CGRect(x: h.minX, y: v.minY, width: h.width, height: v.height)
    }

    private var aspect: CGFloat { width / height }
}

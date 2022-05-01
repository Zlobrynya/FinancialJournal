//
//  File.swift
//
//
//  Created by narongrit kanhanoi on 5/3/2563 BE.
//
// https://github.com/heart/CarBode-Barcode-Scanner-For-SwiftUI

import Foundation
import SwiftUI

public struct CBBarcodeView: UIViewRepresentable {
    public typealias UIViewType = BarcodeView
    public typealias OnBarcodeGenerated = (UIImage?) -> Void

    public enum BarcodeType: String {
        case qrCode = "CIQRCodeGenerator"
        case barcode128 = "CICode128BarcodeGenerator"
        case aztecCode = "CIAztecCodeGenerator"
        case PDF417 = "CIPDF417BarcodeGenerator"
    }

    public enum Orientation {
        case up
        case down
        case right
        case left
    }

    @Binding public var data: String
    @Binding public var barcodeType: BarcodeType
    @Binding public var orientation: Orientation

    private var onGenerated: OnBarcodeGenerated?

    public init(
        data: Binding<String>,
        barcodeType: Binding<BarcodeType>,
        orientation: Binding<Orientation>,
        onGenerated: OnBarcodeGenerated?
    ) {
        _data = data
        _barcodeType = barcodeType
        _orientation = orientation
        self.onGenerated = onGenerated
    }

    public func makeUIView(context: UIViewRepresentableContext<CBBarcodeView>) -> CBBarcodeView.UIViewType {
        let view = BarcodeView()
        view.onGenerated = onGenerated
        return view
    }

    public func updateUIView(_ uiView: BarcodeView, context: UIViewRepresentableContext<CBBarcodeView>) {
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        uiView.gen(data: data, barcodeType: barcodeType)
        uiView.rotate(orientation: orientation)
    }
}

public class BarcodeView: UIImageView {
    private var data: String?
    private var barcodeType: CBBarcodeView.BarcodeType?
    var onGenerated: CBBarcodeView.OnBarcodeGenerated?

    func gen(data: String?, barcodeType: CBBarcodeView.BarcodeType) {
        guard let string = data, !string.isEmpty else {
            image = nil
            return
        }

        self.data = data
        self.barcodeType = barcodeType

        let data = string.data(using: String.Encoding.utf8)
        let filter = CIFilter(name: barcodeType.rawValue)!
        filter.setValue(data, forKey: "inputMessage")
        let output = filter.outputImage

        let extWidth: CGFloat = output?.extent.size.width ?? 0.0
        let extHeight: CGFloat = output?.extent.size.height ?? 0.0

        let scaleX = bounds.width / extWidth
        let scaleY = bounds.height / extHeight

        let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        let scaledImage = output?.transformed(by: transform)

        if let scaledImage = scaledImage {
            let newImage = UIImage(ciImage: scaledImage)
            image = newImage

            if let img = image {
                DispatchQueue.main.async {
                    self.onGenerated?(img)
                }
            }
        } else {
            DispatchQueue.main.async {
                self.onGenerated?(nil)
            }
        }
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        guard let barcodeType = barcodeType else { return }
        gen(data: data, barcodeType: barcodeType)
    }

    private func radians(_ degrees: Float) -> Float {
        return degrees * .pi / 180
    }

    func rotate(orientation: CBBarcodeView.Orientation) {
        if orientation == .right {
            image = image?.rotate(radians: radians(90))
        } else if orientation == .left {
            image = image?.rotate(radians: radians(-90))
        } else if orientation == .up {
            image = image?.rotate(radians: radians(0))
        } else if orientation == .down {
            image = image?.rotate(radians: radians(180))
        }
    }
}

private extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        if let context = UIGraphicsGetCurrentContext() {
            context.translateBy(x: newSize.width / 2, y: newSize.height / 2)
            context.rotate(by: CGFloat(radians))
            draw(in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
        }
        return nil
    }
}

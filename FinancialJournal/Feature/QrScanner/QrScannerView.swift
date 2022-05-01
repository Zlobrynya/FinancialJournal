//
//  QrScannerView.swift
//  FinancialJournal
//
//  Created by Nikita Nikitin on 24.04.2022.
//

import SwiftUI

private enum Constants {
    static let sizeQrFrame = UIScreen.main.bounds.size.width / 1.5
    static let startY = (UIScreen.main.bounds.size.width - sizeQrFrame) / 2
    static let startX = (UIScreen.main.bounds.size.height - sizeQrFrame) / 2
}

struct QrScannerView: View {
    var body: some View {
        CBScanner(
            supportBarcode: [.qr],
            scanInterval: 1,
            onFound: {
                print("BarCodeType =", $0.type.rawValue, "Value =", $0.value)
            },
            onCheck: { rect in
                let correctBounds = CGRect(
                    x: Constants.startX,
                    y: Constants.startY,
                    width: Constants.sizeQrFrame,
                    height: Constants.sizeQrFrame
                )
                return correctBounds.contains(rect)
            }
        )
        .overlay(overlay)
        .ignoresSafeArea(.all, edges: .all)
    }

    private var overlay: some View {
        ZStack {
            Color.white.opacity(0.3)
            RoundedRectangle(cornerRadius: 15)
                .frame(width: Constants.sizeQrFrame, height: Constants.sizeQrFrame)
                .blendMode(.destinationOut)
        }
    }

    private func checkRect(_ rect: CGRect) -> Bool {
        let correctBounds = CGRect(
            x: Constants.startX,
            y: Constants.startY,
            width: Constants.sizeQrFrame,
            height: Constants.sizeQrFrame
        )
        Log.debug(rect)
        return correctBounds.contains(rect)
    }
}

struct QrScannerView_Previews: PreviewProvider {
    static var previews: some View {
        QrScannerView()
    }
}

public extension View {
    @inlinable
    func reverseMask<Mask: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ mask: () -> Mask
    ) -> some View {
        self.mask {
            Rectangle()
                .overlay(alignment: alignment) {
                    mask()
                        .blendMode(.destinationOut)
                }
        }
    }
}

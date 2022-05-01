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
    @State var isAnimating = false

    var body: some View {
        CBScanner(
            supportBarcode: [.qr],
            scanInterval: 1,
            onFound: {
                print("BarCodeType =", $0.type.rawValue, "Value =", $0.value)
            },
            onCheck: checkRect
        )
        .overlay(overlay)
        .ignoresSafeArea(.all, edges: .all)
    }

    private var overlay: some View {
        Color.white.opacity(0.3)
            .reverseMask {
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: Constants.sizeQrFrame, height: Constants.sizeQrFrame)
            }
            .overlay(
                Rectangle().fill(.red)
                    .frame(width: Constants.sizeQrFrame, height: 2)
                    .offset(y: isAnimating ? Constants.startX + Constants.sizeQrFrame : Constants.startX)
                    .animation(Animation.linear(duration: 4).repeatForever(), value: isAnimating),
                alignment: .top
            )
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.white, lineWidth: 6)
                    .frame(width: Constants.sizeQrFrame + 5, height: Constants.sizeQrFrame + 5)
            }
            .onAppear {
                isAnimating = true
            }
    }

    private func checkRect(_ rect: CGRect) -> Bool {
        let correctBounds = CGRect(
            x: Constants.startX,
            y: Constants.startY,
            width: Constants.sizeQrFrame,
            height: Constants.sizeQrFrame
        )
        return correctBounds.contains(rect)
    }
}

struct QrScannerView_Previews: PreviewProvider {
    static var previews: some View {
        QrScannerView()
    }
}

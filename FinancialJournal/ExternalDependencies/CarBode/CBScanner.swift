//
//  ContentView.swift
//  CarBode
//
//  Created by narongrit kanhanoi on 7/10/2562 BE.
//  Copyright © 2562 PAM. All rights reserved.
//
// https://github.com/heart/CarBode-Barcode-Scanner-For-SwiftUI

import AVFoundation
import SwiftUI

public struct CBScanner: UIViewRepresentable {
    public typealias OnFound = (BarcodeData) -> Void
    public typealias OnDraw = (BarcodeFrame) -> Void
    public typealias OnCheck = (CGRect) -> Bool

    public typealias UIViewType = CameraPreview

    public var supportBarcode: [AVMetadataObject.ObjectType]

    @Binding
    public var torchLightIsOn: Bool

    public var scanInterval: Double

    @Binding
    public var cameraPosition: AVCaptureDevice.Position

    @Binding
    public var mockBarCode: BarcodeData

    public let isActive: Bool

    public var onFound: OnFound?
    public var onDraw: OnDraw?
    public var onCheck: OnCheck?

    public init(
        supportBarcode: [AVMetadataObject.ObjectType],
        torchLightIsOn: Binding<Bool> = .constant(false),
        scanInterval: Double = 3,
        cameraPosition: Binding<AVCaptureDevice.Position> = .constant(.back),
        mockBarCode: Binding<BarcodeData> = .constant(BarcodeData(value: "barcode value", type: .qr)),
        isActive: Bool = true,
        onFound: @escaping OnFound,
        onDraw: OnDraw? = nil,
        onCheck: OnCheck? = nil
    ) {
        _torchLightIsOn = torchLightIsOn
        _cameraPosition = cameraPosition
        _mockBarCode = mockBarCode
        self.supportBarcode = supportBarcode
        self.scanInterval = scanInterval
        self.isActive = isActive
        self.onFound = onFound
        self.onDraw = onDraw
        self.onCheck = onCheck
    }

    public func makeUIView(context: UIViewRepresentableContext<CBScanner>) -> CBScanner.UIViewType {
        let view = CameraPreview()
        view.scanInterval = scanInterval
        view.supportBarcode = supportBarcode
        view.setupScanner()
        view.onFound = onFound
        view.onDraw = onDraw
        view.onCheck = onCheck
        view.mockBarCode = mockBarCode
        return view
    }

    public static func dismantleUIView(_ uiView: CameraPreview, coordinator: ()) {
        uiView.session?.stopRunning()
    }

    public func updateUIView(_ uiView: CameraPreview, context: UIViewRepresentableContext<CBScanner>) {
        uiView.setTorchLight(isOn: torchLightIsOn)
        uiView.setCamera(position: cameraPosition)
        uiView.scanInterval = scanInterval
        uiView.setSupportedBarcode(supportBarcode: supportBarcode)

        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)

        if isActive {
            if !(uiView.session?.isRunning ?? false) {
                uiView.session?.startRunning()
            }
            uiView.updateCameraView()
        } else {
            uiView.session?.stopRunning()
        }
    }
}

//
//  QrScannerViewModel.swift
//  FinancialJournal
//
//  Created by Nikita Nikitin on 02.05.2022.
//

import SwiftUI

final class QrScannerViewModel: ObservableObject {
    // MARK: - External Dependencies

    private let model: QrScannerModelProtocol
    private unowned let coordinator: FnsMainTabCoordinator

    // MARK: - Lifecycle

    init(coordinator: FnsMainTabCoordinator, model: QrScannerModelProtocol = QrScannerModel()) {
        self.model = model
        self.coordinator = coordinator
    }

    // MARK: - Public functions

    func foundQrData(_ stringData: String) {}
}

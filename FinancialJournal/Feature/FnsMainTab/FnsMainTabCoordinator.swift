//
//  FnsMainTabCoordinator.swift
//  FinancialJournal
//
//  Created by Nikita Nikitin on 02.05.2022.
//

import SwiftUI

final class FnsMainTabCoordinator: ObservableObject {
    @Published var qrScannerViewModel: QrScannerViewModel?
    @Published var loginFnsViewModel: LoginFnsViewModel?

    init(sessionId: OptionalStringValue = SessionIdValue()) {
        if sessionId.value != nil {
            openQrScanner()
        } else {
            openLoginFns()
        }
    }

    func openLoginFns() {
        DispatchQueue.main.async {
            self.loginFnsViewModel = .init(coordinator: self)
        }
    }

    func openQrScanner() {
        DispatchQueue.main.async {
            self.loginFnsViewModel = nil
            self.qrScannerViewModel = .init(coordinator: self)
        }
    }
}

//
//  QrScannerModel.swift
//  FinancialJournal
//
//  Created by Nikita Nikitin on 02.05.2022.
//

import Foundation

protocol QrScannerModelProtocol {
    
}

struct QrScannerModel: QrScannerModelProtocol {
    
    private let sessionId: OptionalStringValue
    
    init(sessionId: OptionalStringValue = SessionIdValue()) {
        self.sessionId = sessionId
    }
}

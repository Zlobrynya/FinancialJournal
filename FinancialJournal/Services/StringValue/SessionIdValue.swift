//
//  SessionIdValue.swift
//  FinancialJournal
//
//  Created by Nikita Nikitin on 24.04.2022.
//

import Foundation

struct SessionIdValue: OptionalStringValue {
    var value: String? {
        try? keychainStore.getStoredValue(for: .sessionId)
    }

    private var keychainStore: KeychainStoreProtocol

    init(keychainStore: KeychainStoreProtocol) {
        self.keychainStore = keychainStore
    }

    func updateValue(_ value: String) {
        do {
            try keychainStore.storeValue(value, type: .sessionId)
        } catch {
            Log.error(error)
        }
    }
}

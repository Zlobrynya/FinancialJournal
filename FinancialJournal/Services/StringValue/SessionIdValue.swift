//
//  SessionIdValue.swift
//  FinancialJournal
//
//  Created by Nikita Nikitin on 24.04.2022.
//

import Foundation

struct SessionIdValue: OptionalStringValue {
    var value: String? {
        try? keychainStore.getStoredValue(for: .sessionId, service: Keys.fns)
    }

    private var keychainStore: KeychainStoreProtocol

    init(keychainStore: KeychainStoreProtocol = KeychainStore()) {
        self.keychainStore = keychainStore
    }
}

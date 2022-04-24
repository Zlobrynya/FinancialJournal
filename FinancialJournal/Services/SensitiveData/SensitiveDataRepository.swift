//
//  SensitiveDataRepository.swift
//  FinancialJournal
//
//  Created by Nikita Nikitin on 24.04.2022.
//

import Foundation

protocol SensitiveDataRepositoryProtocol {
    func storeSessionData(_ sessionData: SessionData)
}

struct SensitiveDataRepository: SensitiveDataRepositoryProtocol {
    
    // MARK: - External Dependencies
    
    private var keychainStore: KeychainStoreProtocol
    
    // MARK: - Lifecycle
    
    init(keychainStore: KeychainStoreProtocol = KeychainStore()) {
        self.keychainStore = keychainStore
    }
    
    // MARK: - Public functions
    
    func storeSessionData(_ sessionData: SessionData) {
        do {
            try keychainStore.storeValue(sessionData.sessionId, type: .sessionId)
            try keychainStore.storeValue(sessionData.refreshToken, type: .refreshToken)
        } catch {
            Log.error(error)
        }
    }
}

//
//  KeychainStore.swift
//  FinancialJournal
//
//  Created by Nikita Nikitin on 24.04.2022.
//

import Foundation

enum KeychainValueType: String {
    case sessionId
    case refreshToken
}

protocol KeychainStoreProtocol {
    func storeValue(_ value: String, type: KeychainValueType, isSynchronizableNeeded: Bool) throws
    func getStoredValue(for type: KeychainValueType) throws -> String
    func deleteStoredValue(for type: KeychainValueType) throws
}

extension KeychainStoreProtocol {
    func storeValue(_ value: String, type: KeychainValueType, isSynchronizableNeeded: Bool = true) throws {
        try storeValue(value, type: type, isSynchronizableNeeded: isSynchronizableNeeded)
    }
}

struct KeychainStore: KeychainStoreProtocol {

    enum Error: LocalizedError {
        case creatingValueDataFailed
        case noValue
        case unexpectedValueData
        case errSecDuplicateItem
        case unhandledError(status: OSStatus)

        var errorDescription: String? {
            switch self {
            case .creatingValueDataFailed:
                return "Creating value data from string failed."
            case .noValue:
                return "No value found in keychain."
            case .unexpectedValueData:
                return "Could not decode value data."
            case .errSecDuplicateItem:
                return "Item already exists in keychain."
            case let .unhandledError(status):
                return "Unhandled error with status code \(status)."
            }
        }

        init(status: OSStatus) {
            switch status {
            case -25299:
                self = .errSecDuplicateItem
            default:
                self = .unhandledError(status: status)
            }
        }
    }

    // MARK: - Public functions

    func storeValue(_ value: String, type: KeychainValueType, isSynchronizableNeeded: Bool = true) throws {
        guard let valueData = value.data(using: String.Encoding.utf8) else {
            throw Error.creatingValueDataFailed
        }

        let attributes: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrAuthenticationType as String: type.rawValue,
            kSecValueData as String: valueData,
            kSecAttrSynchronizable as String: isSynchronizableNeeded,
        ]

        let status = SecItemAdd(attributes as CFDictionary, nil)
        guard status == errSecSuccess else { throw Error(status: status) }
    }

    func getStoredValue(for type: KeychainValueType) throws -> String {
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrAuthenticationType as String: type.rawValue,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true,
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(attributes as CFDictionary, &item)
        guard status != errSecItemNotFound else { throw Error.noValue }
        guard status == errSecSuccess else { throw Error(status: status) }

        guard
            let existingItem = item as? [String: Any],
            let valueData = existingItem[kSecValueData as String] as? Data,
            let value = String(data: valueData, encoding: String.Encoding.utf8)
        else { throw Error.unexpectedValueData }

        return value
    }

    func deleteStoredValue(for type: KeychainValueType) throws {
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrAuthenticationType as String: type.rawValue,
        ]

        let status = SecItemDelete(attributes as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw Error(status: status)
        }
    }
}

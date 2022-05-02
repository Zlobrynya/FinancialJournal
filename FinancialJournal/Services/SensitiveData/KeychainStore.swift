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
    case test
}

protocol KeychainStoreProtocol {
    func storeValue(_ value: String, type: KeychainValueType, service: String) throws
    func getStoredValue(for type: KeychainValueType, service: String) throws -> String
    func deleteStoredValue(for type: KeychainValueType, service: String) throws
}

extension KeychainStoreProtocol {
    func storeValue(_ value: String, type: KeychainValueType, service: String) throws {
        try storeValue(value, type: type, service: service)
    }
}

struct KeychainStore: KeychainStoreProtocol {
    enum Error: LocalizedError, Equatable {
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

    func storeValue(_ value: String, type: KeychainValueType, service: String) throws {
        guard let valueData = value.data(using: String.Encoding.utf8) else {
            throw Error.creatingValueDataFailed
        }

        let attributes = [
            kSecValueData: valueData,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: type.rawValue,
        ] as CFDictionary

        let status = SecItemAdd(attributes, nil)
        if status != errSecSuccess {
            let error = Error(status: status)
            Log.error(error)
            if error == .errSecDuplicateItem {
                try updateValue(value, type: type, service: service)
            } else {
                throw error
            }
        }
    }

    func updateValue(_ value: String, type: KeychainValueType, service: String) throws {
        guard let valueData = value.data(using: String.Encoding.utf8) else {
            throw Error.creatingValueDataFailed
        }

        let query = [
            kSecAttrService: service,
            kSecAttrAccount: type.rawValue,
            kSecClass: kSecClassGenericPassword,
        ] as CFDictionary

        let attributes = [
            kSecValueData as String: valueData,
        ] as CFDictionary

        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)

        guard status != errSecItemNotFound else {
            throw Error.noValue
        }

        guard status == errSecSuccess else {
            throw Error(status: status)
        }
    }

    func getStoredValue(for type: KeychainValueType, service: String) throws -> String {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: type.rawValue,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true,
        ] as CFDictionary

        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)
        guard status != errSecItemNotFound else { throw Error.noValue }
        guard status == errSecSuccess else { throw Error(status: status) }

        guard
            let existingItem = result as? Data,
            let itemString = String(data: existingItem, encoding: String.Encoding.utf8)
        else { throw Error.unexpectedValueData }

        return itemString
    }

    func deleteStoredValue(for type: KeychainValueType, service: String) throws {
        let attributes = [
            kSecAttrService: service,
            kSecAttrAccount: type.rawValue,
            kSecClass: kSecClassGenericPassword,
        ] as CFDictionary

        let status = SecItemDelete(attributes)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw Error(status: status)
        }
    }
}

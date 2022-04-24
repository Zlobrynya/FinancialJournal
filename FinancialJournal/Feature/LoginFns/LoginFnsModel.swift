//
//  LoginFnsModel.swift
//  FinancialJournal
//
//  Created by Nikita Nikitin on 23.04.2022.
//

import Foundation
import NetworkFramework

enum LoginFnsError: LocalizedError {
    case conventToUrlFailed
}

protocol LoginFnsModelProtocol {
    func esiaLink() async throws -> URL
    func authorization(by code: String, and state: String) async throws -> SessionData
}

final class LoginFnsModel: LoginFnsModelProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func esiaLink() async throws -> URL {
        let url = Api.baseUrl + Api.esiaUrl
        let responce = try await networkService.request(url, method: .get, responceType: EsiaUrlDto.self)
        guard let esiaUrl = URL(string: responce.url) else { throw LoginFnsError.conventToUrlFailed }
        return esiaUrl
    }

    func authorization(by code: String, and state: String) async throws -> SessionData {
        let parameters = EsiaLoginParameters(
            authorizationCode: code,
            timestamp: String(Date().timeIntervalSince1970),
            state: state,
            clientSecret: Keys.clientSecret
        )
        return try await networkService.request(
            Api.baseUrl + Api.auth,
            method: .post,
            bodyParameters: parameters,
            headers: Api.headers,
            responceType: SessionData.self
        )
    }
}

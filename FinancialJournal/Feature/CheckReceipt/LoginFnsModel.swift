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
}

final class LoginFnsModel: LoginFnsModelProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func esiaLink() async throws -> URL {
        let url = Api.baseUrl + Api.esiaLink
        let responce = try await networkService.request(url, method: .get, responceType: EsiaLinkDto.self)
        guard let esiaUrl = URL(string: responce.url) else { throw LoginFnsError.conventToUrlFailed }
        return esiaUrl
    }
}

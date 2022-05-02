//
//  LoginFnsViewModel.swift
//  FinancialJournal
//
//  Created by Nikita Nikitin on 23.04.2022.
//

import SwiftUI

final class LoginFnsViewModel: ObservableObject, Identifiable {

    // MARK: - Public properties

    @Published var esiaUrl: URL?
    @Published var shouldStopLoadingWebView = false {
        didSet {
            guard shouldStopLoadingWebView else { return }
            esiaUrl = nil
        }
    }
    
    var id: UUID = UUID()

    // MARK: - External Dependencies

    private let model: LoginFnsModelProtocol
    private let sensitiveDataRepository: SensitiveDataRepositoryProtocol
    private unowned let coordinator: FnsMainTabCoordinator

    // MARK: - Lifecycle

    init(
        coordinator: FnsMainTabCoordinator,
        model: LoginFnsModelProtocol = LoginFnsModel(),
        sensitiveDataRepository: SensitiveDataRepositoryProtocol = SensitiveDataRepository()
    ) {
        self.model = model
        self.coordinator = coordinator
        self.sensitiveDataRepository = sensitiveDataRepository
    }

    // MARK: - Public functions

    func fetchEsiaUrl() {
        Task {
            do {
                let url = try await model.esiaLink()
                await MainActor.run {
                    esiaUrl = url
                }
            } catch {
                Log.error(error)
            }
        }
    }

    func webViewDidRedirect(with url: URL) {
        shouldStopLoadingWebView = url.absoluteString.contains(Api.baseUrl)
        guard
            shouldStopLoadingWebView,
            let url = URLComponents(string: url.absoluteString),
            let queryItems = url.queryItems,
            let code = queryItems.first?.value,
            let state = queryItems.last?.value
        else { return }
        fetchSession(code: code, state: state)
    }
    
    private func fetchSession(code: String, state: String) {
        Task.detached { [weak coordinator, model, sensitiveDataRepository] in
            do {
                let sessionData = try await model.authorization(by: code, and: state)
                sensitiveDataRepository.storeSessionData(sessionData)
                coordinator?.openQrScanner()
            } catch {
                Log.error(error)
            }
        }
    }
}

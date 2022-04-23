//
//  LoginFnsViewModel.swift
//  FinancialJournal
//
//  Created by Nikita Nikitin on 23.04.2022.
//

import SwiftUI

final class LoginFnsViewModel: ObservableObject {

    // MARK: - Public properties

    @Published var esiaUrl: URL?

    // MARK: - External Dependencies

    private let model: LoginFnsModelProtocol

    // MARK: - Lifecycle

    init(model: LoginFnsModelProtocol = LoginFnsModel()) {
        self.model = model
    }

    // MARK: - Public functions

    func fetchEsiaUrl() {
        Task.detached { [weak self] in
            guard let self = self else { return }
            do {
                let url = try await self.model.esiaLink()
                await MainActor.run {
                    self.esiaUrl = url
                }
            } catch {
                print(error)
            }
        }
    }
}

extension URL: Identifiable {
    public var id: String {
        self.absoluteString
    }
}

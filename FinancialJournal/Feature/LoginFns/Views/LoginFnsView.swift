//
//  LoginFnsView.swift
//  FinancialJournal
//
//  Created by Nikita Nikitin on 09.04.2022.
//

import SwiftUI

struct LoginFnsView: View {

    // MARK: - External Dependencies

    @ObservedObject var viewModel: LoginFnsViewModel
    @State private var shouldStopLoading = false

    // MARK: - Body

    var body: some View {
        VStack(spacing: 16) {
            Asset.loginRecieptIcon.image
                .resizable()
                .frame(
                    width: UIScreen.main.bounds.size.height * 0.4,
                    height: UIScreen.main.bounds.size.height * 0.4
                )
            information
            Spacer()
            buttonEsia
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Colors.primaryBg.color)
        .fullScreenCover(item: $viewModel.esiaUrl, content: { url in
            esiaWebView(for: url)
        })
    }

    // MARK: - Views

    private var information: some View {
        VStack(alignment: .leading, spacing: 11) {
            Text(Localizable.LoginFns.title)
                .font(.boldOpenSans20)
            Text(Localizable.LoginFns.description)
                .font(.regularOpenSans14)
        }
        .multilineTextAlignment(.leading)
        .padding(.horizontal, 34)
    }

    private var buttonEsia: some View {
        Button(
            action: viewModel.fetchEsiaUrl,
            label: { Text(Localizable.LoginFns.esia) }
        )
        .buttonStyle(.primary)
        .padding([.bottom, .horizontal], 16)
    }

    private func esiaWebView(for url: URL) -> some View {
        NavigationView {
            WebView(
                url: url,
                shouldStopLoading: $viewModel.shouldStopLoadingWebView,
                didRedirect: { url, _ in
                    viewModel.webViewDidRedirect(with: url)
                }
            )
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(Localizable.General.close, action: { viewModel.esiaUrl = nil })
                })
            })
        }
    }
}

struct LoginFns_Previews: PreviewProvider {
    static var previews: some View {
        LoginFnsView(viewModel: .init(coordinator: .init()))
    }
}

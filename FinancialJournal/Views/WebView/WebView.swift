//
//  WebView.swift
//  FinancialJournal
//
//  Created by Nikita Nikitin on 09.04.2022.
//

import SwiftUI
import WebKit

enum WKWebViewError: LocalizedError {
    case clientError
    case serverError

    var errorDescription: String? {
        switch self {
        case .clientError:
            return "Clint error. Probably there is no connection with Internet."
        case .serverError:
            return "Internal server error."
        }
    }
}

struct WebView: UIViewRepresentable {

    // MARK: - External Dependencies

    private var url: URL?
    @Binding private var shouldStopLoading: Bool

    private var didStart: ((URL) -> Void)?
    private var didCommit: ((URL) -> Void)?
    private var didFinish: ((URL) -> Void)?
    private var didError: ((WKWebViewError) -> Void)?
    private var didRedirect: ((URL, [HTTPCookie]) -> Void)?

    // MARK: - Lifecycle

    init(
        url: URL?,
        shouldStopLoading: Binding<Bool>,
        didStart: ((URL) -> Void)? = nil,
        didRedirect: ((URL, [HTTPCookie]) -> Void)? = nil,
        didCommit: ((URL) -> Void)? = nil,
        didFinish: ((URL) -> Void)? = nil,
        didError: ((WKWebViewError) -> Void)? = nil
    ) {
        self.url = url
        _shouldStopLoading = shouldStopLoading
        self.didStart = didStart
        self.didRedirect = didRedirect
        self.didCommit = didCommit
        self.didFinish = didFinish
        self.didError = didError
    }

    // MARK: - Public Functions

    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
        view.navigationDelegate = context.coordinator
        guard let request = url else { return view }
        view.load(URLRequest(url: request))
        return view
    }

    func updateUIView(_ uiView: WKWebView, context _: Context) {
        if shouldStopLoading { uiView.stopLoading() }
    }

    func makeCoordinator() -> WebView.Coordinator {
        Coordinator(
            didStart: didStart,
            didRedirect: didRedirect,
            didCommit: didCommit,
            didFinish: didFinish,
            didError: didError
        )
    }

    class Coordinator: NSObject, WKNavigationDelegate {

        // MARK: - External Dependencies

        private var didStart: ((URL) -> Void)?
        private var didRedirect: ((URL, [HTTPCookie]) -> Void)?
        private var didCommit: ((URL) -> Void)?
        private var didFinish: ((URL) -> Void)?
        private var didError: ((WKWebViewError) -> Void)?

        // MARK: - Lifecycle

        init(
            didStart: ((URL) -> Void)?,
            didRedirect: ((URL, [HTTPCookie]) -> Void)?,
            didCommit: ((URL) -> Void)?,
            didFinish: ((URL) -> Void)?,
            didError: ((WKWebViewError) -> Void)?
        ) {
            self.didStart = didStart
            self.didRedirect = didRedirect
            self.didCommit = didCommit
            self.didFinish = didFinish
            self.didError = didError
        }

        // MARK: - WKNavigationDelegate Conformance

        func webView(_ webView: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
            guard let url = webView.url else { return }
            didStart?(url)
        }

        func webView(_ webView: WKWebView, didCommit _: WKNavigation!) {
            guard let url = webView.url else { return }
            didCommit?(url)
        }

        func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
            guard let url = webView.url else { return }
            didFinish?(url)
        }

        func webView(_: WKWebView, didFailProvisionalNavigation _: WKNavigation!, withError error: Error) {
            if (error as NSError).code == NSURLErrorCancelled { return }
            didError?(WKWebViewError.clientError)
        }

        func webView(
            _: WKWebView,
            decidePolicyFor navigationResponse: WKNavigationResponse,
            decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void
        ) {
            if let response = navigationResponse.response as? HTTPURLResponse {
                if response.statusCode >= 400 {
                    didError?(WKWebViewError.serverError)
                }
            }
            decisionHandler(.allow)
        }

        func webView(
            _ webView: WKWebView,
            didReceiveServerRedirectForProvisionalNavigation _: WKNavigation!
        ) {
            guard let url = webView.url else { return }
            WKWebsiteDataStore.default().httpCookieStore.getAllCookies { [weak self] cookies in
                guard let self = self else { return }
                self.didRedirect?(url, cookies)
            }
        }
    }
}

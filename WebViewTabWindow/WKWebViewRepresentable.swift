//
//  WKWebViewRepresentable.swift
//  WebViewTabWindow
//
//  Created by Kevin Yulias on 26/03/23.
//

import SwiftUI
import WebKit

struct WKWebViewRepresentable: UIViewRepresentable {
    
    typealias UIViewType = WKWebView

    var url: URL
    var webView: WKWebView
    
    init(url: URL, webView: WKWebView = WKWebView()) {
        self.url = url
        self.webView = webView
    }
    
    func makeUIView(context: Context) -> WKWebView {
        webView.uiDelegate = context.coordinator
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

extension WKWebViewRepresentable {
    
    final class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate {

        var parent: WKWebViewRepresentable
        private var webViews: [WKWebView]
        
        init(_ parent: WKWebViewRepresentable) {
            self.parent = parent
            self.webViews = []
        }
        
        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            
            if navigationAction.targetFrame == nil {
                
                // Approach 1
                 webView.load(navigationAction.request)
                
                // Approach 2
                let popupWebView = WKWebView(frame: .zero, configuration: configuration)
                popupWebView.navigationDelegate = self
                popupWebView.uiDelegate = self

                parent.webView.addSubview(popupWebView)
                popupWebView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    popupWebView.topAnchor.constraint(equalTo: parent.webView.topAnchor),
                    popupWebView.bottomAnchor.constraint(equalTo: parent.webView.bottomAnchor),
                    popupWebView.leadingAnchor.constraint(equalTo: parent.webView.leadingAnchor),
                    popupWebView.trailingAnchor.constraint(equalTo: parent.webView.trailingAnchor)
                ])

                self.webViews.append(popupWebView)
                return popupWebView
            }
            
            return nil
        }
    }
}

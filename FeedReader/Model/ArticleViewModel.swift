//
//  ArticleViewModel.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 30/03/21.
//

import Foundation
import SafariServices
import WebKit

class ArticleViewModel: NSObject,ObservableObject {
    var article:FeedEntry
    var errorMessage = ""
    @Published var showError = false
    @Published var showSpinner = true
    
    init(withArticle article:FeedEntry) {
        self.article = article
    }
}

#if os(iOS)
extension ArticleViewModel: SFSafariViewControllerDelegate {
    func safariViewController(_ controller: SFSafariViewController,
                              didCompleteInitialLoad didLoadSuccessfully: Bool) {
        if didLoadSuccessfully == false {
            showError = true
            errorMessage = "Error while loading article"
        }
        showSpinner = false
    }
}
#endif

extension ArticleViewModel: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showError = true
        errorMessage = "Error while loading article"
        showSpinner = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showSpinner = false
    }
}

//
//  ArticleView.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 28/03/21.
//

import SwiftUI
import SafariServices
import WebKit

struct ArticleView: View {
    @ObservedObject var viewModel:ArticleViewModel
    
    var body: some View {
        if viewModel.showError {
            Text(viewModel.errorMessage)
        }
        ZStack {
            if let url = viewModel.article.url {
                //SafariView(url: url, delegate: viewModel)
                WebKitView(url: url, delegate: viewModel)
            }
            if viewModel.showSpinner {
                ProgressView()
            }
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    let delegate:SFSafariViewControllerDelegate

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = delegate
        return safariVC
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
        
    }
}

struct WebKitView: UIViewRepresentable {
    let url: URL
    let delegate:WKNavigationDelegate
    
    func makeUIView(context: Context) -> some UIView {
        let webView = WKWebView()
        webView.navigationDelegate = delegate
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}


fileprivate let testEntry = FeedEntry(title: "Title",
                                      urlString: "https://www.apple.com",
                                      category: "",
                                      feedName: "Test")

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(viewModel: ArticleViewModel(withArticle: testEntry))
    }
}

//
//  ArticleView.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 28/03/21.
//

import SwiftUI
import SafariServices

struct ArticleView: View {
    @ObservedObject var viewModel:ArticleViewModel
    
    var body: some View {
        if viewModel.showError {
            Text(viewModel.errorMessage)
        }
        else if let url = viewModel.article.url {
            SafariView(url: url, delegate: viewModel)
        }
    }
    
    private let safariDelegate = SafariViewDelegate()
}

struct SafariView:UIViewControllerRepresentable {
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

fileprivate class SafariViewDelegate:NSObject, SFSafariViewControllerDelegate {
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        
    }
}

fileprivate let testEntry = FeedEntry(title: "Title",
                                      urlString: "https://www.apple.com",
                                      category: "")

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(viewModel: ArticleViewModel(withArticle: testEntry))
    }
}

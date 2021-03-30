//
//  ArticleView.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 28/03/21.
//

import SwiftUI
import SafariServices

struct ArticleView: View {
    var url:URL
    var body: some View {
        SafariView(url: url)
    }
}

struct SafariView:UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        let safariVC = SFSafariViewController(url: url)
        return safariVC
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
        
    }
}

fileprivate let testURL = URL(string:"https://www.apple.com")!

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(url:testURL)
    }
}

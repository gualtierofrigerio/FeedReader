//
//  ArticleViewModel.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 30/03/21.
//

import Foundation
import SafariServices

class ArticleViewModel: NSObject,ObservableObject {
    var article:FeedEntry
    var errorMessage = ""
    @Published var showError = false
    
    init(withArticle article:FeedEntry) {
        self.article = article
    }
}

extension ArticleViewModel: SFSafariViewControllerDelegate {
    func safariViewController(_ controller: SFSafariViewController,
                              didCompleteInitialLoad didLoadSuccessfully: Bool) {
        if didLoadSuccessfully == false {
            showError = true
            errorMessage = "Error while loading article"
        }
    }
}

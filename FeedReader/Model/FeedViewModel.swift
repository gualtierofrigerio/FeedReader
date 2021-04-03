//
//  FeedViewModel.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 27/03/21.
//

import Combine
import Foundation

class FeedViewModel:ObservableObject {
    @Published var feed:Feed = Feed(entries: [])
    // selectedEntry is @Published so once we select an entry
    // the SwiftUI view will reload and have access to showAlert and showSheet
    @Published var selectedArticleViewModel:ArticleViewModel?
    var showAlert = false
    var showSheet = false
    
    var errorMessage:String = ""
    
    init() {
        if let url = Bundle.main.url(forResource: "test", withExtension: "xml") {
            let xmlHelper = XMLHelper()
            let publisher = xmlHelper.parseXML(atURL: url, elementName: "item")
            cancellable = publisher.sink { xmlArray in
                if let xmlArray = xmlArray {
                    self.feed = Feed.createFromArray(xmlArray)
                }
            }
        }
    }
    
    func userSelectedEntry(_ entry:FeedEntry) {
        selectedArticleViewModel = ArticleViewModel(withArticle: entry)
        if let _ = entry.url {
            showSheet = true
        }
        else {
            errorMessage = "Cannot open article"
            showAlert = true
        }
    }
    
    // MARK: - Private
    private var cancellable:AnyCancellable?
}

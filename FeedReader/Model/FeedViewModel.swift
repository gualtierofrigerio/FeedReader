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
    @Published var feedName = "Feed"
    // selectedEntry is @Published so once we select an entry
    // the SwiftUI view will reload and have access to showAlert and showSheet
    @Published var selectedArticleViewModel:ArticleViewModel?
    @Published var selectedArticleIsFavorite = false
    @Published var showAlert = false
    @Published var showSheet = false
    
    
    var errorMessage:String = ""
    
    var categories:[String] = {
        FeedTopicHelper.classNames
    }()
    
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
        self.favoritesHandler = FavoritesHandler.shared
    }
    
    init(withURLString urlString:String) {
        if let url = URL(string: urlString) {
            loadFromURL(url)
        }
    }
    
    init(withEntries entries:[FeedEntry], title:String) {
        self.feed = Feed(entries: entries)
    }
    
    init(withFeedEntry entry:FeedListEntry) {
        switch entry.type {
        case .online:
            if let url = URL(string: entry.url) {
                loadFromURL(url)
            }
        case .favorites:
            feed = Feed(entries: favoritesHandler.getFavoritesFeedEntries())
            type = .favorites
        }
        feedName = entry.name
    }
    
    func closeSheet() {
        showSheet = false
    }
    
    func entryIsFavorite(_ entry:FeedEntry) -> Bool {
        favoritesHandler.isArticleFavorite(article: entry)
    }
    
    func entryToggleFavorite(_ entry:FeedEntry) {
        favoritesHandler.toggleFavorite(entry:entry)
        refreshFeed()
    }
    
    func selectedArticleToggleFavorite() {
        guard let selectedArticleViewModel = selectedArticleViewModel else { return }
        let article = selectedArticleViewModel.article
        entryToggleFavorite(article)
        selectedArticleIsFavorite = favoritesHandler.isArticleFavorite(article: article)
    }
    
    func userSelectedEntry(_ entry:FeedEntry) {
        selectedArticleIsFavorite = favoritesHandler.isArticleFavorite(article: entry)
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
    private var favoritesHandler:FavoritesHandler = FavoritesHandler.shared
    private var feedTopicHelper = FeedTopicHelper()
    private var type:FeedListEntryType = .online
    
    private func loadFromURL(_ url:URL) {
        let xmlHelper = XMLHelper()
        let publisher = xmlHelper.parseXML(atURL: url, elementName: "item")
        cancellable = publisher.sink { xmlArray in
            if let xmlArray = xmlArray {
                self.feed = Feed.createFromArray(xmlArray)
            }
        }
    }
    
    private func refreshFeed() {
        if type == .favorites {
            feed = Feed(entries: favoritesHandler.getFavoritesFeedEntries())
        }
        else {
            objectWillChange.send()
        }
    }
}

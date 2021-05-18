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
    @Published var selectedArticleViewModel:ArticleViewModel?
    @Published var selectedArticleIsFavorite = false
    @Published var showAlert = false
    @Published var showProgressView = false
    @Published var showSheet = false
    
    var showFeedNameInEntry: Bool {
        type != .online
    }
    
    
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
                    self.feed = Feed.createFromArray(xmlArray, feedName:"Feed Name")
                }
            }
        }
        self.favoritesHandler = FavoritesHandler.shared
    }
    
    init(withURLString urlString:String) {
        if let url = URL(string: urlString) {
            loadFromURL(url, feedName: "Feed Name")
        }
    }
    
    init(withEntries entries:[FeedEntry], title:String) {
        self.feed = Feed(entries: entries)
    }
    
    init(withFeedEntry entry:FeedListEntry) {
        feedListEntry = entry
        feedName = entry.name
        loadFeedListEntry(entry)
    }
    
    func closeSheet() {
        showSheet = false
    }
    
    func entryIsFavorite(_ entry:FeedEntry) -> Bool {
        favoritesHandler.isArticleFavorite(article: entry)
    }
    
    func entryToggleFavorite(_ entry:FeedEntry) {
        favoritesHandler.toggleFavorite(entry:entry)
        refreshFeed(forceReload: false)
    }
    
    func refreshFeed(forceReload:Bool) {
        if isReloading {
            return
        }
        if type == .favorites {
            feed = Feed(entries: favoritesHandler.getFavoritesFeedEntries())
        }
        else {
            if forceReload {
                if let entry = feedListEntry {
                    showProgressView = true
                    isReloading = true
                    loadFeedListEntry(entry)
                }
            }
            else {
                objectWillChange.send()
            }
        }
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
    private var feedListEntry:FeedListEntry?
    private var feedTopicHelper = FeedTopicHelper()
    private var isReloading = false
    private var type:FeedListEntryType = .online
    
    private func loadEntriesFromURL(_ url:URL, feedName:String) -> AnyPublisher<[FeedEntry], Never> {
        let xmlHelper = XMLHelper()
        return xmlHelper.parseXML(atURL: url, elementName: "item")
        .map {
            Feed.feedEntriesFromArray($0 ?? [], feedName: feedName)
        }.eraseToAnyPublisher()
    }
    
    private func loadFeedListEntry(_ entry:FeedListEntry) {
        switch entry.type {
        case .online:
            if let url = URL(string: entry.url) {
                loadFromURL(url, feedName: entry.name)
            }
        case .favorites:
            feed = Feed(entries: favoritesHandler.getFavoritesFeedEntries())
            type = .favorites
        case .aggregated:
            type = .aggregated
            if let aggregated = entry.aggregated {
                loadFromAggregatedEntries(aggregated)
            }
        }
    }
    
    private func loadFromAggregatedEntries(_ entries:[FeedListEntry]) {
        var publishers:[AnyPublisher<[FeedEntry], Never>] = []
        for aggregatedEntry in entries {
            if let url = URL(string: aggregatedEntry.url) {
                publishers.append(loadEntriesFromURL(url, feedName: aggregatedEntry.name))
            }
        }
        cancellable = Publishers.MergeMany(publishers)
            .collect(publishers.count)
            .sink(receiveValue: { allEntries in
                self.feed = Feed.init(entries: allEntries.flatMap { $0 })
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.showProgressView = false
                    self.isReloading = false
            }
            
        })
    }
        
    private func loadFromURL(_ url:URL, feedName:String) {
        let xmlHelper = XMLHelper()
        let publisher = xmlHelper.parseXML(atURL: url, elementName: "item")
        cancellable = publisher.sink { xmlArray in
            if let xmlArray = xmlArray {
                self.feed = Feed.createFromArray(xmlArray, feedName: feedName)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.showProgressView = false
                    self.isReloading = false
                }
            }
        }
    }
}

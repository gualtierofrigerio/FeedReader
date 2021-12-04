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
    @Published var feedEntries: [FeedEntry] = []
    @Published var feedName = "Feed"
    @Published var searchText = ""
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
        configureSearch()
    }
    
    init(withFeedEntry entry:FeedListEntry) {
        feedListEntry = entry
        feedName = entry.name
        loadFeedListEntry(entry)
        configureSearch()
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
    
    @available(iOS 15.0, macOS 12.0, *)
    func refreshFeedAsync(forceReload: Bool) async {
        if isReloading {
            return
        }
        if type == .favorites {
            feed = Feed(entries: favoritesHandler.getFavoritesFeedEntries())
        }
        else {
            if forceReload {
                if let entry = feedListEntry,
                   let feed = await loadFeedFromListEntry(entry) {
                    self.feed = feed
                }
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
    private var searchCancellable: AnyCancellable?
    private var type:FeedListEntryType = .online
    
    private func configureSearch() {
        searchCancellable = $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { text in
                self.filterFeed(text:text)
            }
    }
    
    private func filterFeed(text: String) {
        feedEntries = feed.filterEntries(text: text)
    }
    
    private func loadEntriesFromURL(_ url:URL, feedName:String) -> AnyPublisher<[FeedEntry], Never> {
        let xmlHelper = XMLHelper()
        return xmlHelper.parseXML(atURL: url, elementName: "item")
        .map {
            Feed.feedEntriesFromArray($0 ?? [], feedName: feedName)
        }.eraseToAnyPublisher()
    }
    
    @available(iOS 15.0, macOS 12.0, *)
    private func loadEntriesFromURL(_ url: URL, feedName: String) async -> [FeedEntry]? {
        let xmlHelper = XMLHelper()
        if let array = await xmlHelper.parseXML(atURL: url, elementName: "item") {
            return Feed.feedEntriesFromArray(array, feedName: feedName)
        }
        return nil
    }
    
    @available(iOS 15.0, macOS 12.0, *)
    private func loadFeedFromListEntry(_ entry: FeedListEntry) async -> Feed? {
        var feed: Feed? = nil
        switch entry.type {
        case .online:
            if let url = URL(string: entry.url) {
                feed = await loadFeedFromURL(url, feedName: entry.name)
            }
        case .favorites:
            feed = Feed(entries: favoritesHandler.getFavoritesFeedEntries())
            type = .favorites
        case .aggregated:
            type = .aggregated
            if let aggregated = entry.aggregated {
                feed = await loadFeedFromAggregatedEntries(aggregated)
            }
        }
        return feed
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
    
    @available(iOS 15.0, macOS 12.0, *)
    private func loadFeedFromAggregatedEntries(_ entries: [FeedListEntry]) async -> Feed? {
        var allEntries: [FeedEntry] = []
        for aggregatedEntry in entries {
            if let url = URL(string: aggregatedEntry.url),
               let entries = await loadEntriesFromURL(url, feedName: feedName) {
                allEntries.append(contentsOf: entries)
            }
        }
        return Feed.init(entries: allEntries)
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
    
    @available(iOS 15.0, macOS 12.0, *)
    private func loadFeedFromURL(_ url: URL, feedName: String) async -> Feed? {
        let xmlHelper = XMLHelper()
        if let xmlArray = await xmlHelper.parseXML(atURL: url, elementName: "item") {
            return Feed.createFromArray(xmlArray, feedName: feedName)
        }
        return nil
    }
}

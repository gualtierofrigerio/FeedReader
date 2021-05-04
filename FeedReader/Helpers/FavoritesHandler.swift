//
//  FavoritesHandler.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 20/04/21.
//

import Foundation

struct FavoritesEntry {
    var feedName:String
    var title:String
    var url:String
    var image:String
    var category:String
}

extension FavoritesEntry {
    static func fromFeedEntry(entry:FeedEntry) -> Self {
        let imageUrl = entry.image?.absoluteString ?? ""
        return FavoritesEntry(feedName: entry.feedName,
                              title: entry.title,
                              url: entry.urlString,
                              image: imageUrl,
                              category: entry.category)
    }
}

class FavoritesHandler {
    static let shared = FavoritesHandler()
    
    init() {
        favorites = []
        loadFavorites()
    }
    
    func addToFavorites(entry:FeedEntry) {
        let favoritesEntry = FavoritesEntry.fromFeedEntry(entry: entry)
        favorites.append(favoritesEntry)
        saveFavorites()
    }
    
    func getFavoritesEntries() -> [FavoritesEntry] {
        favorites
    }
    
    func getFavoritesFeedEntries() -> [FeedEntry] {
        favorites.map {
            FeedEntry(title: $0.title,
                      urlString: $0.url,
                      category: $0.category,
                      image: URL(string:$0.image),
                      feedName: $0.feedName)
        }
    }
    
    func isArticleFavorite(article:FeedEntry) -> Bool {
        favorites.contains { entry in
            if entry.url == article.urlString {
                return true
            }
            return false
        }
    }
    
    func toggleFavorite(entry:FeedEntry) {
        if let index = favorites.firstIndex(where: {
            $0.url == entry.urlString
        }) {
            favorites.remove(at:index)
        }
        else {
            addToFavorites(entry:entry)
        }
        saveFavorites()
    }
    
    // MARK: - Private
    
    private var favorites:[FavoritesEntry]
    
    private func loadFavorites() {
        if let fav = StorageUtils.loadFavorites() {
            favorites = fav
        }
    }
    
    private func saveFavorites() {
        StorageUtils.saveFavorites(favorites)
    }
}

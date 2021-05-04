//
//  StorageUtils.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 20/04/21.
//

import Foundation

typealias ArrayDictionaryStrings = [[String:String]]

class StorageUtils {
    static func loadFavorites() -> [FavoritesEntry]? {
        if let array = loadArray(key: "favorites") {
            var favorites:[FavoritesEntry] = []
            for element in array {
                if let favoriteEntry = FavoritesEntry.fromDictionary(element) {
                    favorites.append(favoriteEntry)
                }
            }
            return favorites
        }
        return nil
    }
    
    static func loadFeedEntries() -> ArrayDictionaryStrings? {
        guard let array = loadArray(key: "feed_entries") else {
            return nil
        }
        return array
    }
    
    static func saveFavorites(_ favorites:[FavoritesEntry]) {
        let array = favorites.map {
            $0.toDictionary()
        }
        saveArray(array, forKey: "favorites")
    }
    
    static func saveFeedEntries(_ entries:ArrayDictionaryStrings) {
        saveArray(entries, forKey: "feed_entries")
    }
    
    // MARK: - Private
    
    private static func loadArray(key: String) -> ArrayDictionaryStrings? {
        let defaults = UserDefaults.standard
        if let array = defaults.object(forKey: key) as? [[String:String]] {
            return array
        }
        return nil
    }
    
    private static func saveArray(_ array:ArrayDictionaryStrings, forKey: String) {
        let defaults = UserDefaults.standard
        defaults.set(array, forKey: forKey)
    }
}

extension FavoritesEntry {
    static func fromDictionary(_ dictionary:[String:String]) -> Self? {
        guard let feed = dictionary["feed"],
           let title = dictionary["title"],
           let url = dictionary["url"],
           let image = dictionary["image"],
           let category = dictionary["category"] else {
            return nil
        }
        return FavoritesEntry(feedName: feed,
                              title: title,
                              url: url,
                              image: image,
                              category: category)
    }
    
    func toDictionary() -> [String:String] {
        ["feed" : feedName, "title" : title, "url" : url, "image" : image, "category" : category]
    }
}

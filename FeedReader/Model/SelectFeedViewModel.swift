//
//  SelectFeedViewModel.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 15/04/21.
//

import Foundation

class SelectFeedViewModel: ObservableObject {
    @Published var feedList:FeedList = FeedList(entries: [])
    
    init() {
        loadEntries()
    }
    
    func addEntry(name: String, url: String) {
        feedList.addEntry(FeedListEntry(name: name, url: url, type: .online))
        saveEntries()
    }
    
    // MARK: - Private
    
    private func loadEntries() {
        let defaults = UserDefaults.standard
        if let entries = defaults.object(forKey: "feed_entries") as? [FeedListEntry] {
            feedList = FeedList(entries: entries)
        }
    }
    
    private func saveEntries() {
        let defaults = UserDefaults.standard
        defaults.set(feedList.entries, forKey: "feed_entries")
    }
}

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
    
    func removeEntry(offset:IndexSet) {
        feedList.entries.remove(atOffsets: offset)
        saveEntries()
    }
    
    // MARK: - Private
    
    private func loadEntries() {
        let defaults = UserDefaults.standard
        if let entriesArray = defaults.object(forKey: "feed_entries") as? [[String:String]] {
            feedList = FeedList.initWithArray(entriesArray)
        }
    }
    
    private func saveEntries() {
        let defaults = UserDefaults.standard
        let entries = feedList.toArray()
        defaults.set(entries, forKey: "feed_entries")
    }
}

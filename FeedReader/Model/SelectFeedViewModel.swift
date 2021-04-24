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
        if let entriesArray = StorageUtils.loadFeedEntries() {
            feedList = FeedList.initWithArray(entriesArray)
        }
        if feedList.entries.contains(where: { entry in
            entry.type == .favorites
        }) == false {
            feedList.addEntry(FeedListEntry(name: "Favorites", url: "", type: .favorites))
        }
    }
    
    private func saveEntries() {
        let entries = feedList.toArray()
        StorageUtils.saveFeedEntries(entries)
    }
}

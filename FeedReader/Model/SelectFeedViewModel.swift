//
//  SelectFeedViewModel.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 15/04/21.
//

import Foundation

class SelectFeedViewModel: ObservableObject {
    @Published var aggregatedButtonDisabled = true
    @Published var feedList:FeedList = FeedList(entries: [])
    @Published var newAggregatedFeedName = "" {
        didSet {
            updateAggregatedButtonState()
        }
    }
    @Published var selectedFeedEntries:[SelectedListEntry] = []
    @Published var showNewFeedView = false
    
    init() {
        loadEntries()
    }
    
    func addEntry(name: String, url: String) {
        feedList.addEntry(FeedListEntry(name: name, url: url, type: .online))
        saveEntries()
        showNewFeedView = false
    }
    
    func addAggregatedEntries() {
        let aggregated = feedList.entries.filter { entry in
            if let _ = selectedFeedEntries.first(where: {$0.name == entry.name && $0.selected}) {
                return true
            }
            return false
        }
        feedList.addEntry(FeedListEntry(name: newAggregatedFeedName,
                                        url: "",
                                        type: .aggregated,
                                        aggregated: aggregated))
        saveEntries()
        showNewFeedView = false
    }
    
    func clearSelectedEntries() {
        selectedFeedEntries = feedList.entries.filter({
            $0.type == .online
        })
        .map {
            SelectedListEntry(name:$0.name, selected: false)
        }
    }
    
    func removeEntry(offset:IndexSet) {
        feedList.entries.remove(atOffsets: offset)
        saveEntries()
    }
    
    func tapOnNewFeed() {
        showNewFeedView = true
        clearSelectedEntries()
    }
    
    func toggleSelectedEntry(name:String) {
        if let index = selectedFeedEntries.firstIndex(where: {
            $0.name == name
        }) {
            var entry = selectedFeedEntries[index]
            entry.selected.toggle()
            selectedFeedEntries[index] = entry
        }
        updateAggregatedButtonState()
    }
    
    func updateAggregatedButtonState() {
        if newAggregatedFeedName.count > 0 {
            if let _ = selectedFeedEntries.first(where: {
                $0.selected == true
            }) {
                aggregatedButtonDisabled = false
            }
            else {
                aggregatedButtonDisabled = true
            }
        }
        else {
            aggregatedButtonDisabled = true
        }
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
    
    struct SelectedListEntry {
        var name:String
        var selected:Bool
    }
}



//
//  SelectFeed.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 15/04/21.
//

import Foundation
import SwiftUI

struct SelectFeed: View {
    var favoritesHandler = FavoritesHandler.shared
    @ObservedObject var viewModel:SelectFeedViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Add new feed")
                    .padding()
                Button {
                    showSheet.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
            List {
                ForEach(viewModel.feedList.entries, id:\.name) { entry in
                    Button {
                        selectFeedEntry(entry)
                    } label: {
                        HStack {
                            Text(entry.name)
                            Spacer()
                            switch entry.type {
                            case .online:
                                Image(systemName: "network")
                            case .favorites:
                                Image(systemName: "heart")
                            }
                        }
                    }
                }
                .onDelete(perform:deleteElement)
            }
            NavigationLink(destination: dynamicDestination(), isActive: $enableDynamicDestination) {}
        }
        .navigationBarTitle("Your feeds")
        .sheet(isPresented: $showSheet, onDismiss: clearNewFeedEntries) {
            sheetAddFeed
        }
    }
    
    @State private var enableDynamicDestination = false
    @State private var newFeedName = ""
    @State private var newFeedURL = ""
    @State private var selectedEntry:FeedListEntry?
    @State private var showSheet = false
    
    private func addEntry() {
        viewModel.addEntry(name: newFeedName, url: newFeedURL)
        showSheet = false
        clearNewFeedEntries()
    }
    
    private func clearNewFeedEntries() {
        newFeedName = ""
        newFeedURL = ""
    }
    
    private func deleteElement(at offset:IndexSet) {
        viewModel.removeEntry(offset:offset)
    }
    
    // MARK: - Dynamic built destination
    
    @ViewBuilder private func dynamicDestination() -> some View {
        if let selectedEntry = selectedEntry {
            feedViewForEntry(selectedEntry)
        }
        else {
            Group {}
        }
    }
    
    private func feedViewForEntry(_ entry:FeedListEntry) -> some View {
        let feedViewModel = FeedViewModel(withFeedEntry: entry)
        return FeedView(viewModel: feedViewModel)
    }
    
    private func selectFeedEntry(_ entry:FeedListEntry) {
        selectedEntry = entry
        enableDynamicDestination = true
    }
    
    // MARK: - Add feed
    private var sheetAddFeed: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("Name", text: $newFeedName)
                    TextField("URL", text: $newFeedURL)
                }
                Button {
                    addEntry()
                } label: {
                    Text("Confirm")
                }
            }
            .navigationTitle("Add new feed")
        }
    }
}

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
                    viewModel.tapOnNewFeed()
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
                            case .aggregated:
                                Image(systemName: "a.circle")
                            }
                        }
                    }
                }
                .onDelete(perform:deleteElement)
            }
            NavigationLink(destination: dynamicDestination(), isActive: $enableDynamicDestination) {}
        }
        .navigationBarTitle("Your feeds")
        .sheet(isPresented: $viewModel.showNewFeedView) {
            sheetAddFeed
        }
    }
    
    @State private var enableDynamicDestination = false
    @State private var selectedEntry:FeedListEntry?
    
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
        AddNewFeed(viewModel: viewModel)
    }
}

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
            if enableDynamicDestination {
                NavigationLink(destination: dynamicDestination(), isActive: $enableDynamicDestination) {}
            }
        }
        .modifier(ActivityIndicatorModifier(showActivityIndicator: $showActivityIndicator))
        #if os(iOS)
        .navigationBarTitle("Your feeds")
        #endif
        .sheet(isPresented: $viewModel.showNewFeedView) {
            sheetAddFeed
        }
    }
    
    @State private var enableDynamicDestination = false
    @State private var nextFeedView: FeedView?
    @State private var selectedEntry:FeedListEntry?
    @State private var showActivityIndicator = false
    
    private func deleteElement(at offset:IndexSet) {
        viewModel.removeEntry(offset:offset)
    }
    
    // MARK: - Dynamic built destination
    
    @ViewBuilder private func dynamicDestination() -> some View {
        if let nextView = nextFeedView {
            nextView
        }
        else if let selectedEntry = selectedEntry {
            feedViewForEntry(selectedEntry)
        }
        else {
            Group {}
        }
    }
    
    private func feedViewForEntry(_ entry:FeedListEntry) -> FeedView {
        let feedViewModel = FeedViewModel(withFeedEntry: entry)
        let feedView = FeedView(viewModel: feedViewModel)
        return feedView
    }
    
    private func selectFeedEntry(_ entry:FeedListEntry) {
        selectedEntry = entry
        showActivityIndicator = true
        DispatchQueue.global().async {
            let nextView = feedViewForEntry(entry)
            self.nextFeedView = nextView
            DispatchQueue.main.async {
                enableDynamicDestination = true
                showActivityIndicator = false
            }
        }
    }
    
    // MARK: - Add feed
    private var sheetAddFeed: some View {
        AddNewFeed(viewModel: viewModel)
    }
}

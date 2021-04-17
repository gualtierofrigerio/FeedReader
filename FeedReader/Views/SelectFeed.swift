//
//  SelectFeed.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 15/04/21.
//

import Foundation
import SwiftUI

struct SelectFeed: View {
    @ObservedObject var viewModel:SelectFeedViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("List of feeds")
                    .padding()
                Button {
                    showSheet.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
            List(viewModel.feedList.entries, id:\.name) { entry in
                NavigationLink(destination: feedViewForEntry(entry)) {
                    Text(entry.name)
                }
            }
        }
        .navigationBarTitle("Select feed")
        .sheet(isPresented: $showSheet) {
            VStack {
                Form {
                    TextField("Name", text: $newFeedName)
                    TextField("URL", text: $newFeedURL)
                }
                Button {
                    addEntry()
                } label: {
                    Text("Add")
                }
            }
        }
    }
    
    @State private var showSheet = false
    @State private var newFeedName = ""
    @State private var newFeedURL = ""
    
    private func addEntry() {
        viewModel.addEntry(name: newFeedName, url: newFeedURL)
        showSheet = false
    }
    
    private func feedViewForEntry(_ entry:FeedListEntry) -> some View {
        FeedView(viewModel: FeedViewModel(withURLString: entry.url))
    }
}

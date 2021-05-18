//
//  AddNewFeed.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 14/05/21.
//

import SwiftUI

struct AddNewFeed: View {
    @ObservedObject var viewModel:SelectFeedViewModel
    
    var body: some View {
        VStack {
            VStack {
                Text("Add a new Feed")
                    .font(Font.headline)
                    .padding()
                Form {
                    TextField("Name", text: $newFeedName)
                    TextField("URL", text: $newFeedURL)
                }
                Button {
                    addEntry()
                } label: {
                    Text("Add")
                }
                .disabled(newFeedURL.isEmpty || newFeedURL.isEmpty)
            }.frame(height: 250)
            Divider()
                .padding()
            Text("Create an aggregated feed")
                .font(Font.headline)
                .padding()
            Form {
                TextField("Name", text: $viewModel.newAggregatedFeedName)
                List {
                    ForEach(viewModel.selectedFeedEntries, id: \.name) { entry in
                        Button {
                            viewModel.toggleSelectedEntry(name: entry.name)
                        } label: {
                            HStack {
                                Text(entry.name)
                                Spacer()
                                if entry.selected {
                                    Image(systemName: "checkmark.square")
                                }
                                else {
                                    Image(systemName: "square")
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            Button {
                viewModel.addAggregatedEntries()
            } label: {
                Text("Add aggregated")
            }.disabled(viewModel.aggregatedButtonDisabled)
        }
    }
    
    // MARK: - Private
    @State private var newFeedName = ""
    @State private var newFeedURL = ""
    
    private func addAggregatedEntry() {
        viewModel.addAggregatedEntries()
    }
    
    private func addEntry() {
        viewModel.addEntry(name: newFeedName, url: newFeedURL)
        clearNewFeedEntries()
    }
    
    private func clearNewFeedEntries() {
        newFeedName = ""
        newFeedURL = ""
    }
}

struct AddNewFeed_Previews: PreviewProvider {
    static var previews: some View {
        AddNewFeed(viewModel: SelectFeedViewModel())
    }
}

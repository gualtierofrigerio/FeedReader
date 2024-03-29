//
//  ContentView.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 27/03/21.
//

import SwiftUI

struct FeedView: View {
    @ObservedObject var viewModel:FeedViewModel
    
    var body: some View {
        VStack {
            if viewModel.feed.entries.count == 0 {
                Text("Feed empty")
            }
            else {
                if #available(iOS 15.0, macOS 12.0, *) {
                    List(viewModel.feedEntries) { entry in
                        viewForEntry(entry)
                    }
                    .refreshable {
                        await viewModel.refreshFeedAsync(forceReload: true)
                    }
                    .searchable(text: $viewModel.searchText)
                }
                else {
                    RefreshableView(action: {
                        viewModel.refreshFeed(forceReload: true)
                    }) {
                        if viewModel.showProgressView {
                            VStack {
                                ProgressView()
                                Text("reloading feed...")
                                    .font(Font.caption2)
                            }
                        }
                        ForEach(viewModel.feed.entries) { entry in
                            viewForEntry(entry)
                        }
                    }
                }
            }
        }
        .navigationTitle(viewModel.feedName)
        .sheet(isPresented: $viewModel.showSheet) {
            dynamicSheet
        }
        .alert(isPresented: $viewModel.showAlert) {
            dynamicAlert
        }
    }
    
    // MARK: - Private
    @State private var selectedCategory:String = ""
    @State private var selectedEntry:FeedEntry?
    @State private var showCategoryPicker = false
    
    private var dynamicAlert: Alert {
        Alert(title: Text("Error"),
              message: Text(viewModel.errorMessage),
              dismissButton: .default(Text("Ok")))
    }
    
    @ViewBuilder private var dynamicSheet: some View {
        if let articleViewModel = viewModel.selectedArticleViewModel {
            VStack {
                favoritesBar
                ArticleView(viewModel:articleViewModel)
            }
        }
        else {
            Text("Error while opening the requested article")
        }
    }
    
    @ViewBuilder private var favoritesBar: some View {
        HStack {
            Button {
                viewModel.closeSheet()
            } label: {
                Text("Done")
            }.padding()
            Spacer()
            Button {
                viewModel.selectedArticleToggleFavorite()
            } label: {
                HStack {
                    if viewModel.selectedArticleIsFavorite {
                        Image(systemName: "heart.fill")
                    }
                    else {
                        Image(systemName: "heart")
                    }
                }.padding()
            }
        }
    }
    
    private func tapCategoryAction(entry:FeedEntry) {
        showCategoryPicker.toggle()
        selectedEntry = entry
    }
    
    @ViewBuilder private func viewForEntry(_ entry: FeedEntry) -> some View {
        FeedEntryView(entry:entry,
                      showFeedName: viewModel.showFeedNameInEntry,
                      tapCategoryAction: {
            tapCategoryAction(entry: entry)
        },
                      tapOnView: {
            viewModel.userSelectedEntry(entry)
        },
                      toggleFavorite: {
            viewModel.entryToggleFavorite(entry)
        },
                      isFavorite: viewModel.entryIsFavorite(entry))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(viewModel: FeedViewModel())
    }
}

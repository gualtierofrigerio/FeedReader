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
        NavigationView {
            List(viewModel.feed.entries) { entry in
                Button {
                    buttonTap(entry: entry)
                } label: {
                    FeedEntryView(entry:entry)
                }
            }.navigationTitle("Feed")
        }
        .sheet(isPresented: $showSheet) {
            dynamicSheet
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"),
                  message: Text("Cannot open article"),
                  dismissButton: .default(Text("Ok")))
        }
    }
    
    // MARK: - Private
    @State private var showAlert = false
    @State private var showSheet = false
    
    @ViewBuilder private var dynamicSheet: some View {
        if let entry = viewModel.selectedEntry,
           let url = entry.url {
            ArticleView(url: url)
        }
        else {
            Text("Error while opening the requested article")
        }
    }
    
    private func buttonTap(entry:FeedEntry) {
        if let _ = entry.url {
            viewModel.selectedEntry = entry
            showSheet = true
        }
        else {
            showAlert = true
        }
    }
}

struct ConsoleLogView:View {
    init(_ message:String) {
        print(message)
    }
    
    var body: some View {
        EmptyView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(viewModel: FeedViewModel())
    }
}

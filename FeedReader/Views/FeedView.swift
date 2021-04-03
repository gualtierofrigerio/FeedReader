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
                    viewModel.userSelectedEntry(entry)
                } label: {
                    FeedEntryView(entry:entry)
                }
            }.navigationTitle("Feed")
        }
        .sheet(isPresented: $viewModel.showSheet) {
            dynamicSheet
        }
        .alert(isPresented: $viewModel.showAlert) {
            dynamicAlert
        }
    }
    
    // MARK: - Private
    
    private var dynamicAlert: Alert {
        Alert(title: Text("Error"),
              message: Text(viewModel.errorMessage),
              dismissButton: .default(Text("Ok")))
    }
    
    @ViewBuilder private var dynamicSheet: some View {
        if let articleViewModel = viewModel.selectedArticleViewModel {
            ArticleView(viewModel:articleViewModel)
        }
        else {
            Text("Error while opening the requested article")
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
